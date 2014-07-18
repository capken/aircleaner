require "nokogiri"
require "json"
require "uri"
require 'digest/sha1' 

STDIN.each do |url|
  url = url.strip
  warn "\nprocessing page => #{url} ...\n"
  hash = Digest::SHA1.hexdigest(url)
  cached_file = File.open "./cache/#{hash}"

  doc = Nokogiri::HTML(cached_file.read)

  input = {}

  links = doc.css("div.breadcrumb a")
  if links.size == 5 and links[2].to_str == "净化器"
    input['brand'] = links[3].to_str
    input['model'] = links[4].to_str
  end

  doc.css("div#product-detail-2 table tr").each do |tr|
    tds = tr.css("td")
    input[tds.first.to_str] = tds.last.to_str if tds.size == 2
  end

#  doc.css("strong#jd-price").each do |money|
#    input["price"] = money.to_str.gsub(/￥/, '').to_i
#  end

  doc.css("div#spec-n1 img").each do |image|
    input["image"] = URI.join url.strip, image["src"]
  end

  input["_source"] = url

  puts input.to_json
end
