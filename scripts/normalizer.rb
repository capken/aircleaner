require "json"

rules = {}
variables_file_path = File.join(File.dirname(__FILE__), "brand.variables.txt")
File.readlines(variables_file_path).each do |line|
  line = line.strip
  variables = line.gsub /;/, '|'
  regexp = Regexp.new "(?:#{variables})", "i"
  rules[line.split(";").last] = regexp
end

STDIN.each do |json|
  record = JSON[json]

  brand = record["brand"]
  next if brand.nil?
  rules.each do |value, regexp|
    if brand =~ regexp
      brand = value
      break
    end
  end

  model = record["model"]
  next if model.nil?
  #model = model.gsub(rules[brand] || /#{brand}/, '')
  model = model.gsub(/（.*?）|\(.*?\)|空气|净化器|中国红|蓝色|香槟黄|香槟金|土豪金|玫瑰红|银灰|白色|粉色|木纹|迷你/, '')
  model = model.gsub(/\/00$/, '')

  record["brand"] = brand
  record["model"] = model

  puts record.to_json unless record['category'].to_s =~ /滤网|耗材|附件|滤芯|喷香机/
end
