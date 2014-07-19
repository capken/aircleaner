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

  ths = doc.css("div table tr th")
  if ths.size > 2
    if ths.first.to_str =~ /产品名称/
      value = ths[1].to_str.gsub(/\(.+?\)/, '')
      if value =~ /^(.+?) ([0-9A-Z\/ -]+)/i
        input["brand"] = $1
        input["model"] = $2.strip
      end
    end
  end

  tables = doc.css("div table tr").each do |tr|
    tds = tr.css("td")
    input[tds.first.to_str] = tds[1].to_str.strip if tds.size >2
  end

  input["_source"] = url

  puts input.to_json
end
