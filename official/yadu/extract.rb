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

  input["brand"] = "亚都"
  doc.css("div.product_tit").each do |div|
    input["model"] = div.to_str
  end

  doc.css("table.Ptable tr").each do |tr|
    tds = tr.css("td")
    input[tds.first.to_str.strip] = tds.last.to_str if tds.size == 2
  end

  #doc.css("div.undis p").each do |p|
  #  res = p.to_xml.split(/；|<br\/>/).map do |item|
  #    item.gsub(/^\u00a0+|\u00a0+$/, '').gsub(/<\/?.+?>|（.+?）/, '').strip
  #  end.each do |item|
  #    label, value = item.split(/\u00a0+|：/)
  #    input[label] = value
  #  end
  #end

  input["_source"] = url

  doc.css("#spec-n1 > img").each do |image|
    input["image"] = URI.join url.strip, image["src"]
  end

  puts input.to_json
end
