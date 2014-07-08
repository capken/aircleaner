require "nokogiri"
require "json"
require "uri"
require 'digest/sha1' 

STDIN.each do |url|
  url = url.strip
  warn "extraction on #{url}..."
  hash = Digest::SHA1.hexdigest(url)
  cached_file = File.open "./cache/#{hash}"

  doc = Nokogiri::HTML(cached_file.read)
  table = doc.css("div.param_table table").first
  if table
    content = table.to_str

    obj = {}
    links = doc.css("div.breadcrumb a")
    obj["brand"] = links[2].to_str.gsub(/空气净化器/, "") if links.size == 4
    obj["model"] = links.last.to_str.gsub(/#{obj["brand"]}/, "").strip if links.size == 4
    obj["made_in"] = $1 if content =~ /产地：\s*([^\n]+)/
    obj["color"] = $1 if content =~ /颜色[:：]\s*([^\n]+)/
    obj["filter_lifetime"] = $1.to_f if content =~ /滤芯寿命\s*(\d+).*?月/
    obj["filter_material"] = "HEPA" if content =~ /HEPA过滤|HEPA网/
    obj["timing"] = true if content =~ /定时模式|\d小时定时器/
    obj["remote_control"] = $1 if content =~ /遥控功能：\s*([^\n]+)/
    obj["sleep_mode"] = true if content =~ /睡眠模式/
    obj["filter_replacement_reminder"] = true if content =~ /滤网更新提醒/
    obj["air_quality_led"] = true if content =~ /净化度指示灯/
    obj["material"] = $1 || $2 if content =~ /材质：([^\n]+)|机身材料：([^\n]+)/

    if content =~ /外观尺寸.+?(\d+)\*(\d+)\*(\d+)mm/m
      dimensions = {
        "height" => $3.to_i,
        "width"  => $1.to_i,
        "deep"   => $2.to_i
      }
    end
    obj["dimensions"] = dimensions || {}

    obj["weight"] = $1 if content =~ /重量\s*([^\n]+)kg/i

    obj["CADR"] =  {
      "dust" => $1
    } if content =~ /洁净空气量：(\d+)m3\/h/

   if content =~ /噪声\s*[≤]?(\d+)分贝/
      obj["noise_level"] = { "max" => $1.to_i }
   elsif content =~ /噪声\s*强：(\d+)分贝.+?静音：(\d+)分贝/m
     obj["noise_level"] = {
       "min" => $2.to_i,
       "max" => $1.to_i
     } 
   elsif content =~ /噪声\s*(\d+)-(\d+)分贝/m
     obj["noise_level"] = {
       "min" => $1.to_i,
       "max" => $2.to_i
     } 
   end

    power = {
      "max" => $1.to_i
    } if content =~ /功率\s*([^\n]+)W/i
    obj["power"]= power || {}

    obj["air_volume"] = $1.to_i if content =~ /(?:最大风速|风量).+?(\d+)(?:立方米\/小时|m3\/h)/m
    if content =~ /风速\s*.*?([一二三四五六七八九0-9])档/
      obj["total_fan_speed_levels"] = $1
    elsif content =~ /风速\s*([^\n]+)/
      obj["total_fan_speed_levels"] = $1.split(/[，、]/).size
    end

    obj["_source"] = url.strip

    doc.css("div.pic img").each do |image|
      obj["image"] = URI.join url.strip, image["src"]
    end

    obj.each do |k, v|
      obj[k] = v.strip if v.is_a? String
    end

    puts obj.to_json
  end
end
