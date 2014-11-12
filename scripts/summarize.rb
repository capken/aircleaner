require 'json'
require 'uri'
require 'set'
require 'public_suffix'
require 'digest/sha1'

path = File.join(File.dirname(__FILE__), "attr_meta.json")
attr_meta = JSON[File.readlines(path).join]

warn attr_meta

path = File.join(File.dirname(__FILE__), "domain_meta.json")
weight_by_domain = JSON[File.readlines(path).join]

warn weight_by_domain

path = File.join(File.dirname(__FILE__), "brand_meta.json")
brand_metas = JSON[File.readlines(path).join]

warn brand_metas

STDIN.each do |line|
  record = JSON[line]
  summarized_record = {}
  domains = Set.new

  attr_meta.each do |attr, meta|
    votes = record[attr]

    if votes.is_a? Array
      next if votes.empty?

      votes.each do |vote|
        vote['score'] = vote['source'].map do |url|
          host = URI.parse(url).host
          domain = PublicSuffix.parse(host).domain
          domains << domain
          weight_by_domain[domain] || 3.0
        end.reduce(:+)
      end

      summary_value = case meta['summary_mode']
      when 'vote'
        best_vote = votes.inject do |v1, v2|
          v1['score'] > v2['score'] ? v1 : v2
        end
        best_vote['value']
      when 'combine'
        votes.map { |v| v['value'] }.
          reject { |v| v.empty? }.
          join(',')
      when 'min'
        votes.map { |v| v['value'] }.min
      when 'max'
        votes.map { |v| v['value'] }.max
      end

      summarized_record[attr.to_sym] = summary_value
    else
      summarized_record[attr.to_sym] = votes
    end
  end

  domains.delete_if {|domain| domain =~ /ahamdir/ }

  domains_score = domains.map do |domain|
    weight_by_domain[domain] || 3.0
  end.inject(:+).to_f.round(2)

  brand, model = record['brand'], record['model']
  etao_link = "http://m.etao.com/search/search.php?q=#{URI.encode("#{brand} #{model}")}" 

  brand_metas.each do |brand_meta|
    if brand_meta['short_name'] == brand
      summarized_record[:brand] = brand_meta['name'] 
      summarized_record[:is_pro_mfr] = brand_meta['is_pro_mfr'] 
    end
  end

  summarized_record[:popularity] = domains_score
  summarized_record[:etao_link] = etao_link

  summarized_record[:image_hash] = summarized_record[:image].split(',').map do |image_url|
    Digest::SHA1.hexdigest image_url.strip
  end if summarized_record[:image]

  puts summarized_record.to_json if domains_score > 1
end
