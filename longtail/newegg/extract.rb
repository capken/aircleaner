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
  tables = doc.css("div#tab3 table")
  tables.first.css("tr").each do |tr|
    ths = tr.css("th")
    tds = tr.css("td")
    input[ths.first.to_str] = tds.first.to_str if tds.size == 1 and ths.size == 1
  end

  input["_source"] = url

  doc.css("div#spec-n1 img").each do |image|
    input["image"] = URI.join url.strip, image["src"]
  end

  puts input.to_json
end
