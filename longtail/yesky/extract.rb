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
  tables = doc.css("table.paramtable-b tr").each do |tr|
    ths = tr.css("th")
    tds = tr.css("td")
    if tds.size == 2 and tds.size == 2
      kvs[ths[0].to_str] = tds[0].to_str.strip 
      kvs[ths[1].to_str] = tds[1].to_str.strip 
    end
  end

  #warn kvs.to_json

  obj = {}

  links = doc.css("dl.nav a")
  if links.size == 4
    obj["brand"] = links[2].to_str
    obj["model"] = links[3].to_str.
      gsub(obj["brand"], '').
      gsub(/净化清新器|空气净化器/, '').strip
  end

  kvs.each do |title, value|
    case title
    when /外观尺寸/
      if value =~ /(\d+).*?[×x*](\d+).*?[×x*](\d+)/i
        res = [$1.to_i, $2.to_i, $3.to_i].sort
        obj["dimensions"] = {
          "height" => res[2],
          "width"  => res[1],
          "deep"   => res[0]
        } 
      end
    when /重量/
      obj["weight"] = $1.to_f if value =~ /([\d.]+)/
    when /工作噪声/
      noise_level = {}
      if value =~ /^(?:[﹤＜<≤]|小于|低于|等于)*\s*([\d.]+)(?:分贝|db|dba|以下)*\s*$/i
        noise_level['max'] = $1.to_i
      elsif value =~ /^([\d.]+).*?[-－\/].*?([\d.]+)\s*(?:分贝|db)*\s*$/i
        res = [$1.to_i, $2.to_i].sort
        noise_level['min'] = res[0]
        noise_level['max'] = res[1]
      else
        if value =~ /(?:静音档?|宁静|睡眠|弱|低速?|最低噪音)(?:[：:\/]|≤|低于|\s)*([\d.]+)/i or
          value =~ /([\d.]+)[（(](?:静音档?|宁静|休眠|睡眠|弱|低速?|最低噪音|安静)/
          noise_level['min'] = $1.to_i 
        end
        if value =~ /(?:强|高|[急极]速档?|最?高速|最大风速)(?:[：:\/]|≤|低于|\s)*([\d.]+)/i or
          value =~ /([\d.]+)[（(](?:强档?|高|[急极]速档?|最?高速|最[大高]风速|特级强风)/
          noise_level['max'] = $1.to_i 
        end
      end
      obj["noise_level"] = noise_level
    when /功率/
      power = {}
      if value =~ /^(?:小于|最大)?\s*(\d+)(?:W)?$/i
        power["max"] = $1.to_i
      elsif value =~ /(\d+)\/\d+\/(\d+)/
        res = [$1, $2].map(&:to_i).sort
        power["min"] = res.first
        power["max"] = res.last
      elsif value =~ /^(\d+).*?[-－\/].*?(\d+)/
        res = [$1, $2].map(&:to_i).sort
        power["min"] = res.first
        power["max"] = res.last
      else
        power["min"] = $1.to_i if value =~ /(?:低|弱|低速)[\s：]*([\d.]+)/
        power["max"] = $1.to_i if value =~ /(?:高|强|高速)[\s：]*([\d.]+)/
      end
      obj["power"] = power
    when /风量/
      obj["air_volume"] = $1.to_i if value =~ /^([\d.]+)(?:m3\/h|[m³|㎡]\/h|立方米?\/小?时|立方\/H)*$/i
    end

    obj["filter_material"] = "HEPA" if value =~ /HEPA(?:高效)?过滤/
    obj["filter_replacement_reminder"] = true if value =~ /过滤网更换提醒/
    obj["sleep_mode"] = true if value =~ /睡眠模式/
    obj["filter_lifetime"] = $1.to_f*12 if value =~ /滤网使用寿命(\d+)年/
    obj["remote_control"] = true if value =~ /有遥控/
    obj["total_fan_speed_levels"] = $1 if value =~ /(\d+)档风速|风速\s*([二三四五六])档/
  end

  obj["_source"] = url
  doc.css("div.prcurrent img").each do |image|
    obj["image"] = URI.join url.strip, image["src"]
  end

  puts obj.to_json
end
