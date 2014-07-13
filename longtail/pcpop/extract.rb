require "nokogiri"
require "json"
require "uri"
require 'digest/sha1' 

STDIN.each do |url|
  url = url.strip
  hash = Digest::SHA1.hexdigest(url)
  warn "\nprocessing page => #{hash} #{url} ...\n"
  cached_file = File.open "./cache/#{hash}"

  doc = Nokogiri::HTML(cached_file.read)

  kvs = {}
  tables = doc.css("div table tr").each do |tr|
    tds = tr.css("td")
    kvs[tds.first.to_str] = tds[1].to_str.strip if tds.size >2
  end

#  warn kvs.to_json

  obj = {}

  ths = doc.css("div table tr th")
  if ths.size > 2
    if ths.first.to_str =~ /产品名称/
      value = ths[1].to_str.gsub(/\(.+?\)/, '')
      if value =~ /^(.+?) ([0-9A-Z\/ -]+)/i
        obj["brand"] = $1
        obj["model"] = $2.strip
      end
    end
  end

  kvs.each do |title, value|
    case title
    when /产品类型/
      obj["category"] = value
    when /外观/
      obj["color"] = value.gsub(/色.+$/, '色').gsub(/^.+[：:]/, '').strip
    when /重量/
      obj["weight"] = value.to_f
    when /额定功率/
      obj["power"] = {}
      if value =~ /^([\d.]+)\s*(?:w|瓦特|瓦)?$/i
        obj["power"]["max"] = $1.to_f
      elsif value =~ /^([\d.]+)W?[~-]([\d.]+)W?$/i
        obj["power"]["min"] = $1.to_f
        obj["power"]["max"] = $2.to_f
      else
        obj["power"]["min"] = $1.to_f if value =~ /(?:静音|最小)[：:\s]*([0-9.]+)W/i
        obj["power"]["max"] = $1.to_f if value =~ /(?:强力|最高)[：:\s]*([0-9.]+)W/i
      end
    when /尺寸/
      obj["dimensions"] = {
        "height" => $1.to_i,
        "width"  => $2.to_i,
        "deep"   => $3.to_i
      } if value =~ /(\d+)[*x](\d+)[*x](\d+)/i
    when /洁净空气输出量/i
      obj["CADR"] = {
        "dust" => $1.to_i
      } if value =~ /(\d+)/
    when /噪音/
      obj["noise_level"] = {}
      if value =~ /([0-9.]+).*?[-~].*?([0-9.]+)/
        obj["noise_level"]["min"] = $1.to_f
        obj["noise_level"]["max"] = $2.to_f
      elsif value =~ /^(?:《|≤|＜|小于|小于等于|少于|低于|≤dB)?([0-9.]+)(?:\(db\)|dB|dB\s*以下|分贝|（A）|db\(A\)|dB（A）)?\s*(?:\(声压）)?\s*$/i
        obj["noise_level"]["max"] = $1.to_f
      else
        obj["noise_level"]["min"] = $1.to_f if value =~ /(?:静音|低|弱|睡眠)[：:\s]*([0-9.]+)/
        obj["noise_level"]["max"] = $1.to_f if value =~ /(?:强力|高|强|最大)[：:\s]*([0-9.]+)/
      end
    when /风速设定/
      obj["total_fan_speed_levels"] = $1.to_i if value =~ /(\d+)[级档]/
    when /定时功能/
      obj["timing"] = true if value =~ /^支持/
      obj["timing"] = false if value =~ /^不支持/
    when /睡眠模式/
      obj["sleep_mode"] = true if value =~ /^支持/
      obj["sleep_mode"] = false if value =~ /^不支持/
    when /遥控/
      obj["remote_control"] = true if value =~ /^支持/
      obj["remote_control"] = false if value =~ /^不支持/
    when /空气质量提示/
      obj["air_quality_led"] = true if value =~ /^支持/
      obj["air_quality_led"] = false if value =~ /^不支持/
    when /滤网更新提醒/
      obj["filter_replacement_reminder"] = true if value =~ /^支持/
      obj["filter_replacement_reminder"] = false if value =~ /^不支持/
    when /过滤网类型/
      obj["filter_material"] = value
    end
  end

  obj["_source"] = url

  puts obj.to_json unless obj["category"] =~ /滤网|附件产品/
end
