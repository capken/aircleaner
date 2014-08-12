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
  input["brand"] = "松下"

  doc.css("h2.header3").each do |h|
    input["model"] = h.to_str
  end

  doc.css("table.tech_specs tr").each do |tr|
    tds = tr.css("td")
    input[tds.first.to_str.strip] = tds.last.to_str
  end

  input["_source"] = url

  puts input.to_json
end
