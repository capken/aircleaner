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
  doc.css("table.table2 tr").each do |tr|
    tds = tr.css("td")
    input[tds.first.to_str] = tds.last.to_str if tds.size == 2
  end

#  warn kvs.to_json

  input["_source"] = url

  doc.css("img#BigImg").each do |image|
    input["image"] = URI.join url.strip, image["src"]
  end

  doc.css("div.money").each do |money|
    input["price"] = money.to_str
  end

  doc.css('title').each do |title|
    if title.to_str =~ /^([^\s]+) (.+)$/
      input['brand'] = $1
      input['model'] = $2.gsub(/(?:\.\.\.|参数).+$/, '')
    end
  end

  puts input.to_json
end
