require "nokogiri"
require "json"
require "uri"
require 'digest/sha1' 

STDIN.each do |url|
  url = url.strip
  warn "extraction on #{url}..."
  hash = Digest::SHA1.hexdigest(url)
  cached_file = File.open "./cache/#{hash}"

  doc = Nokogiri::HTML(cached_file.read)

  input = {}
  links = doc.css("div.breadcrumb a")
  input["brand"] = links[2].to_str.gsub(/空气净化器/, "") if links.size == 4
  input["model"] = links.last.to_str.gsub(/#{input["brand"]}/, "").strip if links.size == 4
 
  doc.css("ul.category_param_list li").each do |li|
    spans = li.css('span')
    if spans.size == 2
      value = spans.last.to_str
      if value =~ /：/
        value.split("\t").each do |other|
          if other =~ /^(.+?)：(.+)$/
            input[$1] = $2
          end
        end
      else
        input[spans.first.to_str] = value
      end
    end
  end

  input["_source"] = url.strip

  doc.css("div.pic img").each do |image|
    input["image"] = URI.join url.strip, image["src"]
  end

  input.each do |k, v|
    input[k] = v.gsub(/\r\n/, ' ').strip if v.is_a? String
  end

  puts input.to_json
end
