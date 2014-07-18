require "nokogiri"
require 'open-uri'
require "json"

STDIN.each do |url|
  doc = Nokogiri::HTML(open(url.strip))
  doc.css("div#product-detail-2 table").each do |table|
    content = table.to_str
#    warn content
    obj = {}

    if content =~ /品牌(.+?)（(.+?)）型号/
      obj["brand"] = $1 
      obj["model_alias"] = [$2]
    elsif content =~ /品牌(.+?)型号/
      obj["brand"] = $1 
    end

    obj["model"] = $1 if content =~ /型号([A-Za-z0-9 -]+)/

    doc.css("div#spec-n1 img").each do |image|
      obj["image"] = URI.join url.strip, image["src"]
    end

    dimensions = {}
    if content =~ /尺寸\(mm\)(\d+)mm×(\d+)mm×(\d+)mm/i or 
        content =~ /尺寸\(mm\)(\d+)[*x](\d+)[*x](\d+)(?:（mm）)?/i
      dimensions["height"] = $1.to_i
      dimensions["width"] = $2.to_i
      dimensions["deep"] = $3.to_i
    end
    obj["dimensions"] = dimensions

    obj["weight"] = $1.to_f if content =~ /净重（kg\)([0-9.]+)kg/

    cadr = {}
    cadr["dust"] = $1.to_i if content =~ /净化空气率（%）(\d+)M3\/h/
    obj["CADR"] = cadr

    noise_level = {}
    if content =~ /噪音（db\)(\d+)（.+?）- (\d+)（.+?） dB/
      noise_level["min"] = $1.to_i 
      noise_level["max"] = $2.to_i
    end
    obj["noise_level"] = noise_level

    power = {}
    if content =~ /功率\(w\)([0-9]+)w/i
      power["max"] = $1.to_i
    end
    obj["power"]= power

    obj["air_volume"] = -1
    obj["total_fan_speed_levels"] = $1.split(/\n/).size if content =~ /风量模式\s*(.+?)耗电量/m
    obj["filter_lifetime"] = -1
    obj["_source"] = url.strip

    puts obj.to_json
  end
end
