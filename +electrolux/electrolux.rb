require "nokogiri"
require 'open-uri'
require "json"

STDIN.each do |url|
  doc = Nokogiri::HTML(open(url.strip))
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

    cadr = {}
    cadr["dust"] = $1.to_f if content =~ /CADR ([0-9.]+)m³\/h/
    obj["CADR"] = cadr

    obj["noise_level"] = {}
    obj["power"]= {}

    obj["air_volume"] = -1
    obj["total_fan_speed_levels"] = -1
    obj["filter_lifetime"] = -1
    obj["_source"] = url.strip

    puts obj.to_json
  end
end
