require 'json'
require 'uri'
require 'set'
require 'public_suffix'

path = File.join(File.dirname(__FILE__), "attr_meta.json")
attr_meta = JSON[File.readlines(path).join]

warn attr_meta

path = File.join(File.dirname(__FILE__), "domain_meta.json")
weight_by_domain = JSON[File.readlines(path).join]

warn weight_by_domain

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

      summarized_record[attr] = summary_value
    else
      summarized_record[attr] = votes
    end
  end

  domains.delete_if {|domain| domain =~ /ahamdir/ }

  puts summarized_record.to_json if domains.size > 1
end
