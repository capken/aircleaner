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

  doc.css("div.pro-show-top h3").each do |title|
    input["brand"] = "美的"
    input["model"] = title.to_str.gsub /净化器/, ''
  end

  doc.css("#pro_spe tr").each do |tr|
    tds = tr.css("td")
    input[tds.first.to_str] = tds.last.to_str
  end

  input["_source"] = url

  doc.css("div#PicView img").each do |image|
    input["image"] = URI.join url.strip, image["src"]
  end

  puts input.to_json
end
