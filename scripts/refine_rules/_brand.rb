
brand_patterns = {}
path = File.join File.dirname(__FILE__), "brand.variables.txt"
File.readlines(path).each do |line|
  variables = line.strip.split ';'
  brand_patterns[variables.last] = Regexp.new "(?:#{variables.join('|')})", "i"
end

refine do |record|
  brand = record['brand']

  if brand.nil?
    @is_good_record = false
    next
  else
    brand_patterns.each do |offical_brand, pattern|
      if brand =~ pattern
        record['brand'] = offical_brand
        break
      end
    end
  end
end
