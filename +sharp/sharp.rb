require "nokogiri"
require 'open-uri'
require "json"

STDIN.each do |url|
  doc = Nokogiri::HTML(open(url.strip))
  doc.css("div.pd2_tblist table").each do |table|
    content = table.to_str
    obj = {}

    obj["brand"] = "Sharp"

    obj["model"] = url.strip.gsub /^.+\//, ''

    obj["image"] = URI.join url.strip, "/pci_files/images/pci_products/#{obj["model"]}.jpg"

    dimensions = {}
    if content =~ /外形尺寸\(mm\)宽×深×高\s*(\d+)x(\d+)x(\d+)/
      dimensions["height"] = $3.to_i
      dimensions["width"] = $1.to_i
      dimensions["deep"] = $2.to_i
    end
    obj["dimensions"] = dimensions

    obj["weight"] = $1.to_f if content =~ /重量\(kg\)\s*约([0-9.]+)/

    cadr = {}
    cadr["dust"] = $1.to_i if content =~ /洁净空气量CADR\(m3\/h\)\s*(\d+)/
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
