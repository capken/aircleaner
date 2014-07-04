require "nokogiri"
require 'open-uri'
require "json"

STDIN.each do |url|
  doc = Nokogiri::HTML(open(url.strip))
  doc.css("div.techspecs").each do |spec|
    content = spec.to_str
    obj = {}

    obj["brand"] = "Philips"

    doc.css("span.product-ctn").each do |span|
      obj["model"] = span.to_str
    end

    doc.css("img#mainGalleryPic").each do |image|
      obj["image"] = URI.join url.strip, image["src"]
    end

    dimensions = {}
    if content =~ /(?:产品|彩盒)尺寸\s*（宽 x 深 x 高）: (\d+) x (\d+) x (\d+) 毫米/
      dimensions["height"] = $3.to_i
      dimensions["width"] = $1.to_i
      dimensions["deep"] = $2.to_i
    elsif content =~ /(?:过滤网|彩盒)尺寸（高 x 阔 x 深）: (\d+) x (\d+) x (\d+) 毫米/
      dimensions["height"] = $1.to_i
      dimensions["width"] = $2.to_i
      dimensions["deep"] = $3.to_i
    end
    obj["dimensions"] = dimensions

    obj["weight"] = $1.to_f if content =~ /(?:产品重量|彩盒重量（含产品）): ([\d.]+) 千克/

    cadr = {}
    if content =~ /CADR.*?(?:烟雾颗粒|烟味|香烟烟雾).*?(\d+).*?m[³3]\/h/
      cadr["dust"] = $1.to_i 
    elsif content =~ /CADR.*?（(?:灰尘和花粉)）.*?: (\d+) m³\/h/
      cadr["dust"] = $1.to_i 
      cadr["pollen"] = $1.to_i 
    end
    obj["CADR"] = cadr

    noise_level = {}
    if content =~ /噪音级别: (\d+).+?-.+?(\d+).+?分贝/
      noise_level["min"] = $1.to_i 
      noise_level["max"] = $2.to_i
    elsif content =~ /噪音级别: (\d+) dB/i
      noise_level["max"] = $1.to_i
    end
    obj["noise_level"] = noise_level

    power = {}
    if content =~ /功率.*?: (\d+) 瓦/
      power["max"] = $1.to_i
    end
    obj["power"]= power

    obj["air_volume"] = -1
    obj["total_fan_speed_levels"] = -1
    obj["filter_lifetime"] = -1

    obj["material"] = $1 if content =~ /机身(?:材质|材料): ([^\s]+)/
    obj["made_in"] = $1 if content =~ /产地: ([^\s]+)/

    obj["_source"] = url.strip

    puts obj.to_json
  end
end
