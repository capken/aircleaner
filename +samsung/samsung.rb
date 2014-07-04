require "nokogiri"
require 'open-uri'
require "json"

STDIN.each do |url|
  doc = Nokogiri::HTML(open(url.strip))
  doc.css("div#div_bullet_view_content").each do |div|
    content = div.to_str
    obj = {}

    obj["brand"] = "Samsung"

    doc.css("div.pageTitle").each do |title|
      obj["model"] = title.to_str
    end

    doc.css("div.productImage img").each do |image|
      obj["image"] = URI.join url.strip, image["src"]
    end

    dimensions = {}
    if content =~ /净尺寸:(\d+) x (\d+) x (\d+)mm/
      dimensions["height"] = $2.to_i
      dimensions["width"] = $1.to_i
      dimensions["deep"] = $3.to_i
    end
    obj["dimensions"] = dimensions

    obj["weight"] = $1.to_f if content =~ /净重:([0-9.]+)kg/i

    cadr = {}
    cadr["dust"] = $1.to_i if content =~ /洁净空气量:(\d+)/
    obj["CADR"] = cadr

    noise_level = {}
    if content =~ /噪音:高 (\d+)\/低 (\d+)/
      noise_level["min"] = $2.to_i
      noise_level["max"] = $1.to_i
    elsif content =~ /噪音:.*?(\d+)dB/i 
      noise_level["max"] = $1.to_i
    end
    obj["noise_level"] = noise_level

    power = {}
    if content =~ /功耗:.*?([\d.]+)W/i
      power["max"] = $1.to_i
    elsif content =~ /功耗:高 ([\d.]+)\/低 ([\d.]+)/
      power["min"] = $2.to_i
      power["max"] = $1.to_i
    end
    obj["power"]= power

    obj["air_volume"] = -1
    obj["total_fan_speed_levels"] = $1.split('/').size + 1 if content =~ /风速:([^\s]+)/
    obj["filter_lifetime"] = -1
    obj["_source"] = url.strip

    puts obj.to_json
  end
end
