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
  doc.css("div#canshu_box").each do |table|
    content = table.to_str

    obj = {}
    obj["brand"] = $1 if content =~ /品牌：\s*([^\n]+)/
    obj["model"] = $1 if content =~ /型号：\s*([^\n]+)/
    obj["made_in"] = $1 if content =~ /产地：\s*([^\n]+)/
    obj["color"] = $1 if content =~ /颜色：\s*([^\n]+)/
    obj["filter_lifetime"] = $1.to_f if content =~ /滤网使用寿命：\s*(\d+)月/
    obj["filter_material"] = $1 if content =~ /过滤网材质：\s*([^\n]+)/
    obj["timing"] = $1 if content =~ /定时功能：\s*([^\n]+)/
    obj["remote_control"] = $1 if content =~ /遥控功能：\s*([^\n]+)/
    obj["sleep_mode"] = $1 if content =~ /睡眠模式：\s*([^\n]+)/
    obj["filter_replacement_reminder"] = $1 if content =~ /过滤网更新提醒：\s*([^\n]+)/
    obj["air_quality_led"] = $1 if content =~ /空气质量显示：\s*([^\n]+)/

    if content =~ /产品尺寸.+?(\d+)\*(\d+)\*(\d+)毫米/m
      dimensions = {
        "height" => $1.to_i,
        "width"  => $2.to_i,
        "deep"   => $3.to_i
      }
    end
    obj["dimensions"] = dimensions || {}

    obj["weight"] = $1 if content =~ /净重：\s*([^\n]+)千克/

    obj["CADR"] =  {}

    obj["noise_level"] = {}

    power = {
      "max" => $1.to_i
    } if content =~ /额定功率：\s*([^\n]+)瓦特/
    obj["power"]= power || {}

    obj["air_volume"] = $1.to_i if content =~ /风量：\s*(\d+)立方\/时/
    obj["total_fan_speed_levels"] = -1
    obj["_source"] = url.strip

    doc.css("div#PicView img").each do |image|
      obj["image"] = URI.join url.strip, image["src"]
    end

    puts obj.to_json
  end
end
