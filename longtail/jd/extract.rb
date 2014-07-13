require "nokogiri"
require "json"
require "uri"
require 'digest/sha1' 

STDIN.each do |url|
  url = url.strip
  warn "\nprocessing page => #{url} ...\n"
  hash = Digest::SHA1.hexdigest(url)
  cached_file = File.open "./cache/#{hash}"

  doc = Nokogiri::HTML(cached_file.read)

  kvs = {}
  doc.css("div#product-detail-2 table tr").each do |tr|
    tds = tr.css("td")
    kvs[tds.first.to_str] = tds.last.to_str if tds.size == 2
  end

#  warn kvs.to_json

  obj = {}
  kvs.each do |title, value|
    case title
    when /品牌/
      obj["brand"] = value
    when /型号/
      obj["model"] = value.gsub(/空气净化器/, '')
    when /类型/
      obj["category"] = value
    when /产地/
      obj["made_in"] = value
    when /颜色/
      obj["color"] = value
    when /净重/
      obj["weight"] = value.to_f
    when /额定功率/
      if value =~ /^([\d.]+)\s*(?:w|瓦特|瓦)?$/i
        obj["power"] = {
          "max" => $1.to_f
        }
      elsif value =~ /^([\d.]+)W?[~-]([\d.]+)W?$/i
        obj["power"] = {
          "min" => $1.to_f,
          "max" => $2.to_f
        }
      end
    when /材质/
      obj["material"] = "ABS" if value =~ /ABS/i
      obj["material"] = "金属" if value =~ /金属|合金/i
    when /产品尺寸/
      obj["dimensions"] = {
        "height" => $3.to_i,
        "width"  => $1.to_i,
        "deep"   => $2.to_i
      } if value =~ /(\d+) x (\d+) x (\d+)/i
    when /CADR值\(m\?\/h\)/
      obj["CADR"] = {
        "dust" => $1.to_i
      } if value =~ /(\d+)/
    when /噪音/
      obj["noise_level"] = {}
      if value =~ /([0-9.]+).*?[-~].*?([0-9.]+)/
        obj["noise_level"]["min"] = $1.to_f
        obj["noise_level"]["max"] = $2.to_f
      elsif value =~ /^(?:《|≤|＜|小于|小于等于|少于|低于)?([0-9.]+)(?:dB|dB以下|分贝|db\(A\))?$/i
        obj["noise_level"]["max"] = $1.to_f
      else
        obj["noise_level"]["min"] = $1.to_f if value =~ /(?:静音|低)[：\s]*([0-9.]+)/
        obj["noise_level"]["max"] = $1.to_f if value =~ /(?:强力|高)[：\s]*([0-9.]+)/
      end
    when /滤网更新提醒/
      obj["filter_replacement_reminder"] = value
    when /睡眠模式/
      obj["sleep_mode"] = true unless value =~ /无|否|不支持/
    when /遥控/
      obj["remote_control"] = true unless value =~ /无|否|不支持/
    when /空气质量提示/
      obj["air_quality_led"] = true unless value =~ /无|否|不支持/
    end
  end

  obj["_source"] = url

  doc.css("div#spec-n1 img").each do |image|
    obj["image"] = URI.join url.strip, image["src"]
  end

  puts obj.to_json
end
