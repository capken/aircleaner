require "nokogiri"
require "json"
require 'uri'
require 'digest/sha1' 

STDIN.each do |url|
  url = url.strip
  warn "\nprocessing page => #{url} ...\n"
  hash = Digest::SHA1.hexdigest(url)
  cached_file = File.open "./cache/#{hash}"

  doc = Nokogiri::HTML(cached_file.read)

  doc.css("div#content").each do |node|
    content = node.to_str
    obj = {}

    obj["brand"] = "Electrolux"

    obj["model"] = $1 if content =~ /主要功能 于 ([0-9a-zA-Z]+)/

    node.css("img.prodImg").each do |image|
      obj["image"] = URI.join url.strip, image["src"]
    end

    dimensions = {}
    dimensions["height"] = $1.to_i if content =~ /高度\s*\(mm\)\s*(\d+)/
    dimensions["width"] = $1.to_i if content =~ /宽度\s*\(mm\)\s*(\d+)/
    dimensions["deep"] = $1.to_i if content =~ /深度\s*\(mm\)\s*(\d+)/
    obj["dimensions"] = dimensions

    obj["weight"] = $1.to_f if content =~ /净重（kg）\s*([0-9.]+)/

    obj["cadr_dust"] = $1.to_f if content =~ /CADR ([0-9.]+)m³\/h/

    obj["_source"] = url.strip

    puts obj.to_json
  end
end
