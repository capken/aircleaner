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
  input["brand"] = "海尔"
  doc.css("div.tr").each do |tr|
    tds = tr.css("div.td")
    input[tds.first.to_str] = tds.last.to_str
  end

  input["_source"] = url

  doc.css(".js_pic_mid > img").each do |image|
    input["image"] = URI.join url.strip, image["src"]
  end

  puts input.to_json
end
