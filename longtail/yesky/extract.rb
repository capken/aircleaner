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
  doc.css("div.leftbox").each do |div|
    content = div.to_str

    obj = {}

    links = doc.css("dl.nav a")
    if links.size == 4
      obj["brand"] = links[2].to_str
      obj["model"] = links[3].to_str.gsub obj["brand"], ''
    end

    obj["filter_material"] = "HEPA" if content =~ /HEPA(?:高效)?过滤/
    obj["filter_replacement_reminder"] = true if content =~ /过滤网更换提醒/
    obj["sleep_mode"] = true if content =~ /睡眠模式/
    obj["filter_lifetime"] = $1.to_f*12 if content =~ /滤网使用寿命(\d+)年/
    obj["remote_control"] = true if content =~ /有遥控/

    if content =~ /外观尺寸\s*(\d+)×(\d+)×(\d+)mm/
      dimensions = {
        "height" => $3.to_i,
        "width"  => $1.to_i,
        "deep"   => $2.to_i
      }
    end
    obj["dimensions"] = dimensions || {}

    obj["weight"] = $1 if content =~ /重量\(kg\)\s*([\d.]+)/

    cadr = {
      "dust" => $1.to_i
    } if content =~ /CADR\s*([0-9.]+)/ or 
      content =~ /洁净空气量（m3\/h\)\s*(\d+)/ or
      content =~ /洁净空气量：(\d+)m3\/h/ or
      content =~ /CADR值(\d+)（m3\/h）/
    obj["CADR"] = cadr || {}

    if content =~ /工作噪声\(dB\)\s*(\d+)(?:分贝|db)/i
      noise_level = {
        "max" => $1.to_i
      } 
    elsif content =~ /工作噪声\(dB\)\s*高：(\d+)dB.+?低：(\d+)dB/i or 
      content =~ /工作噪声\(dB\)\s*(\d+)（强）.+?(\d+)（弱）分贝/i or
      content =~ /工作噪声\(dB\)\s*强：(\d+).+?静音：(\d+)/i
      noise_level = {
        "min" => $2.to_i,
        "max" => $1.to_i
      } 
    elsif content =~ /工作噪声\(dB\)\s*(\d+)-(\d+)dB/i or
      content =~ /工作噪声\(dB\)\s*(\d+)-\d+-(\d+)dB/
      noise_level = {
        "min" => $1.to_i,
        "max" => $2.to_i
      } 
    end
    obj["noise_level"] = noise_level || {}

    if content =~ /功率\(W\)\s*(\d+)/i
      power = {
        "max" => $1.to_i
      } 
    elsif content =~ /功率\(W\)\s*高：(\d+)W.+?低：(\d+)W/i
      power = {
        "min" => $2.to_i,
        "max" => $1.to_i
      } 
    end
    obj["power"]= power || {}

    obj["air_volume"] = ($1 || $2).to_i if content =~ 
      /额定风量\s*高：(\d+)m3\/h|额定风量\s*(\d+)(?:立方米\/小时|m3\/h)/
    obj["total_fan_speed_levels"] = $1 || $2 if content =~ /(\d+)档风速|风速\s*([二三四五六])档/ 
    obj["_source"] = url.strip

    doc.css("div.prcurrent img").each do |image|
      obj["image"] = URI.join url.strip, image["src"]
    end

    obj.each do |k, v|
      obj[k] = v.strip if v.is_a? String
    end

    puts obj.to_json
  end
end
