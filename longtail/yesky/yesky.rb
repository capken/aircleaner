require "nokogiri"
require 'open-uri'
require "json"
require "yaml"

STDIN.each do |url|
  doc = Nokogiri::HTML(open(url))
  doc.css("div.leftbox").each do |div|
    content = div.to_str
    warn content

    obj = {}

    links = doc.css("dl.nav a")
    if links.size == 4
      obj["brand"] = links[2].to_str
      obj["model"] = links[3].to_str.gsub obj["brand"], ''
    end

    doc.css("div.prcurrent img").each do |image|
      obj["image"] = URI.join url.strip, image["src"]
    end

    if content =~ /外观尺寸\s*(\d+)×(\d+)×(\d+)mm/
      dimensions = {
        "height" => $3.to_i,
        "width"  => $1.to_i,
        "deep"   => $2.to_i
      }
    end
    obj["dimensions"] = dimensions || {}

    obj["weight"] = -1

    cadr = {
      "dust" => $1.to_i
    } if content =~ /CADR\s*([0-9.]+)/
    obj["CADR"] = cadr || {}

    noise_level = {
      "max" => $1.to_i
    } if content =~ /工作噪声\(dB\)\s*(\d+)分贝/i
    obj["noise_level"] = noise_level || {}

    power = {
      "max" => $1.to_i
    } if content =~ /功率\(W\)\s*(\d+)W/i
    obj["power"]= power || {}

    obj["air_volume"] = -1
    obj["total_fan_speed_levels"] = $1 if content =~ /(\d+)档风速/ 
    obj["filter_lifetime"] = -1
#    obj["made_in"] = $1 if content =~ rule["made_in"]
#    obj["material"] = $1 if content =~ rule["material"]
    obj["_source"] = url.strip

    puts obj.to_json
  end
end
