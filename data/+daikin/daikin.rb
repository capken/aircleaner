require "nokogiri"
require 'open-uri'
require "json"

STDIN.each do |url|
  doc = Nokogiri::HTML(open(url.strip))
  doc.css("div.t-guige table").each do |table|
    content = table.to_str
    obj = {}

    obj["brand"] = "Daikin"

    if content =~ /(?:型号|机型)\s*([A-Z0-9]+)\(/
      obj["model"] = $1 
    end

    table.css("img").each do |image|
      obj["image"] = URI.join url.strip, image["src"]
    end

    dimensions = {}
    if content =~ /mm\s*(\d+)×(\d+)×(\d+)/
      dimensions["height"] = $1.to_i
      dimensions["width"] = $2.to_i
      dimensions["deep"] = $3.to_i
    end
    obj["dimensions"] = dimensions

    obj["weight"] = $1.to_f if content =~ /kg\s*([0-9.]+)/

    cadr = {}
    cadr["dust"] = $1.to_i if content =~ /m³\/h\s*\d+\/(\d+)/
    obj["CADR"] = cadr

    noise_level = {}
    if content =~ /dB\(A\)\s*(\d+)\s+(?:\d+\s+)+(\d+)\s*集尘/
      noise_level["min"] = $2.to_i 
      noise_level["max"] = $1.to_i
    end
    obj["noise_level"] = noise_level

    power = {}
    if content =~ /耗电量\s*W\s*(\d+)\s+(?:\d+\s+)+(\d+)\s*(?:风量|加湿量)/
      power["min"] = $2.to_i
      power["max"] = $1.to_i
    end
    obj["power"]= power

    obj["air_volume"] = $1.to_i if content =~ /m³\/h\s*(\d+)\/\d+/
    obj["total_fan_speed_levels"] = $1.split(/\n/).size if content =~ /风量模式\s*(.+?)耗电量/m
    obj["filter_lifetime"] = -1
    obj["_source"] = url.strip

    puts obj.to_json
  end
end
