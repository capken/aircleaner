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

    obj["cadr_dust"] = $1.to_i if content =~ /空气净化率\(m³\/h\)\s*([0-9]+)/

    obj["fan_speed_levels"] = $1.to_i if content =~ /风速调节\s*(\d+)档/
    obj["_source"] = url.strip

    puts obj.to_json
  end
end
