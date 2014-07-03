require "nokogiri"
require "json"

STDIN.each do |file_name|
  file = File.open("./pages/#{file_name.strip}", "r")
  doc = Nokogiri::HTML(file.read)
  record = {}
  trs = doc.css("table#compare tr")
  trs.each_with_index do |tr, i|
    content_text = tr.to_str.gsub(/[\n\t\u00A0]+/, '').strip
    case i
    when 0
      if tr.to_html =~ /src="(.+?)"/
        record["image"] = "http://www.ahamdir.com" + $1
      end
    when 2
      record["brand"] = content_text
    when 3
      if tr.to_html =~ /href="(.*?)"/
        record["website"] = $1
      end
    when 6
      record["model"] = content_text
    when 7
      record["room_size"] = content_text
    when 8
      record["dust_cadr"] = content_text
    when 9
      record["pollen_cadr"] = content_text
    when 10
      record["tobacco_smoke_cadr"] = content_text
    when 11
      record["energy_star"] = content_text
    when 12
      record["meets_ozone_limits"] = content_text
    when 13
      record["voltage_frequency"] = content_text
    when 14
      record["dimensions"] = content_text
    when 15
      record["weight"] = content_text
    end
  end

  puts record.to_json
end
