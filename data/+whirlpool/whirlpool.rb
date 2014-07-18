require "nokogiri"
require 'open-uri'
require "json"

STDIN.each do |url|
  doc = Nokogiri::HTML(open(url.strip))
  doc.css("div.item table").each do |table|
    content = table.to_str
    obj = {}

    obj["brand"] = "Whirlpool"

    if content =~ /产品型号\s*([0-9A-Z-]+)/
      obj["model"] = $1 
    end

    doc.css("a#pro-d-focus").each do |link|
      obj["image"] = URI.join url.strip, link["href"]
    end

    dimensions = {}
    if content =~ /产品尺寸\(mm\)\s*(\d+)\*(\d+)\*(\d+)/
      dimensions["height"] = $3.to_i
      dimensions["width"] = $1.to_i
      dimensions["deep"] = $2.to_i
    end
    obj["dimensions"] = dimensions

    obj["weight"] = $1.to_f if content =~ /产品重量\(Kg\)\s*([0-9.]+)/

    cadr = {}
    cadr["dust"] = $1.to_i if content =~ /空气净化率\(m³\/h\)\s*([0-9]+)/
    obj["CADR"] = cadr

    obj["noise_level"] = {}
    obj["power"]= {}

    obj["air_volume"] = -1
    obj["total_fan_speed_levels"] = $1.to_i if content =~ /风速调节\s*(\d+)档/
    obj["filter_lifetime"] = -1
    obj["_source"] = url.strip

    puts obj.to_json
  end
end
