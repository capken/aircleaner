require "nokogiri"
require "json"
require "uri"
require 'digest/sha1' 

STDIN.each do |url|
  url = url.strip
  hash = Digest::SHA1.hexdigest(url)
  warn "\nprocessing page => #{hash} #{url} ...\n"
  cached_file = File.open "./cache/#{hash}"

  doc = Nokogiri::HTML(cached_file.read)

  input = {}

  links = doc.css("dl.nav a")
  if links.size == 4
    input["brand"] = links[2].to_str
    input["model"] = links[3].to_str.strip
  end

  tables = doc.css("table.paramtable-b tr").each do |tr|
    ths = tr.css("th")
    tds = tr.css("td")
    if tds.size == 2 and tds.size == 2
      input[ths[0].to_str.strip] = tds[0].to_str.strip 
      input[ths[1].to_str.strip] = tds[1].to_str.strip 
    end
  end

  input["_source"] = url

  doc.css("div.prcurrent img").each do |image|
    input["image"] = URI.join url.strip, image["src"]
  end

  puts input.to_json
end
