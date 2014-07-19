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
  doc.css("div#canshu_box table tr").each do |tr|
    tds = tr.css("td")
    if tds.size == 3
      label = tds[0].to_str.gsub(/：/, '').strip
      input[label] = tds[1].to_str
    end

    input["_source"] = url.strip

    doc.css("div#PicView img").each do |image|
      input["image"] = URI.join url.strip, image["src"]
    end
  end

  puts input.to_json
end
