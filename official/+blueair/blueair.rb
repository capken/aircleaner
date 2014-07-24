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

  doc.css("div.product-model-section").each do |table|
    content = table.to_str
    obj = {}

    obj["brand"] = "Blueair"

    if content =~ /([0-9A-Za-z]+) \/ ([0-9A-Za-z]+) 机型/
      obj["model"] = $1 
      obj["model_alias"] = [$2]
    elsif content =~ /([0-9A-Za-z]+) 机型/
      obj["model"] = $1 
    end

    table.css("img").each do |image|
      obj["image"] = URI.join url.strip, image["src"]
    end

    dimensions = {}
    dimensions["height"] = $1.to_i if content =~ /高([0-9]+)mm/
    dimensions["width"] = $1.to_i if content =~ /宽([0-9]+)mm/
    dimensions["deep"] = $1.to_i if content =~ /厚([0-9]+)mm/
    obj["dimensions"] = dimensions

    obj["weight"] = $1.to_f if content =~ /重量：([0-9.]+)kg/

    obj["cadr_dust"] = $1.to_i if content =~ /灰尘.+?\((\d+)m³\/h\)/
    obj["cadr_pollen"] = $1.to_i if content =~ /花粉.+?\((\d+)m³\/h\)/
    obj["cadr_tobacco_smoke"] = $1.to_i if content =~ /烟雾.+?\((\d+)m³\/h\)/

    noise_level = {}
    if content =~ /噪音水平：(\d+)-(\d+)\(dBA\)/
      noise_level["min"] = $1.to_i 
      noise_level["max"] = $2.to_i
    end
    obj["noise_level"] = noise_level

    power = {}
    if content =~ /耗电：(\d+)-(\d+)W/
      power["min"] = $1.to_i
      power["max"] = $2.to_i
    end
    obj["power"]= power

    obj["air_volume"] = $1.to_i if content =~ /风量：(\d+)m³\/h/
    obj["fan_speed_levels"] = $1.to_i if content =~ /风档：(\d+)/
    obj["filter_life"] = $1.to_i if content =~ /滤网平均使用寿命\s*(\d+)个月/
    obj["material"] = $1 if content =~ /材料：([^\s]+)/
    obj["made_in"] = $1 if content =~ /产地\s*([^\s]+)/
    obj["_source"] = url.strip

    puts obj.to_json
  end
end
