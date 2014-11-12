
path = File.join File.dirname(__FILE__), '..' ,"brand_meta.json"
brand_metas = JSON[File.readlines(path).join]

refine do |record|
  brand = record['brand']

  if brand.nil?
    @is_good_record = false
    next
  else
    brand_metas.each do |brand_meta|
      if brand =~ /#{brand_meta['variables']}/i
        record['brand'] = brand_meta['short_name'] || brand_meta['name']
        break
      end
    end
  end
end
