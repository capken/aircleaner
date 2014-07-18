require "nokogiri"
require 'open-uri'
require "json"
require "yaml"

root_path = File.join(File.dirname(__FILE__), "../")

rule = ARGV[0].nil? ? {} : YAML.load_file("#{ARGV[0]}")
common_rule = YAML.load_file(File.join(root_path, "jd/common_rule.yaml"))

rule = common_rule.merge rule
warn rule

STDIN.each do |url|
  doc = Nokogiri::HTML(open(url.strip))
  doc.css("div#product-detail-2 table").each do |table|
    content = table.to_str
    warn content

    obj = {}

    obj["brand"] = $1 if content =~ rule["brand"]
    obj["model"] = $1 if content =~ rule["model"]

    doc.css("div#spec-n1 img").each do |image|
      obj["image"] = URI.join url.strip, image["src"]
    end

    if content =~ rule["dimensions"]
      dimensions = {
        "height" => $3.to_i,
        "width"  => $1.to_i,
        "deep"   => $2.to_i
      }
    end
    obj["dimensions"] = dimensions || {}

    obj["weight"] = $1.to_f if content =~ rule["weight"]

    cadr = {
      "dust" => $1.to_i
    } if content =~ rule["cadr"]
    obj["CADR"] = cadr || {}

    noise_level = {
      "min" => $1.to_i,
      "max" => $2.to_i
    } if content =~ rule["noise"]
    obj["noise_level"] = noise_level || {}

    power = {
      "min" => $1.to_i,
      "max" => $2.to_i
    } if content =~ rule["power"]
    obj["power"]= power || {}

    obj["air_volume"] = -1
    obj["total_fan_speed_levels"] = $1 if content =~ rule["fan_speed_levels"]
    obj["filter_lifetime"] = -1
    obj["made_in"] = $1 if content =~ rule["made_in"]
    obj["material"] = $1 if content =~ rule["material"]
    obj["_source"] = url.strip

    puts obj.to_json
  end
end
