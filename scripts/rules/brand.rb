
brand_patterns = {}
path = File.join File.dirname(__FILE__), "brand.variables.txt"
File.readlines(path).each do |line|
  variables = line.strip.split ';'
  brand_patterns[variables.last] = Regexp.new "(?:#{variables.join('|')})", "i"
end

refine do |record|
  brand = record["brand"]
  if brand.nil?
    @is_good_record = false
    next
  end

  brand_patterns.each_pair do |offical_brand, pattern|
    if brand =~ pattern
      brand = offical_brand
      break
    end
  end

  record['brand'] = brand
end
