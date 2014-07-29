
seeds_file = File.join(File.dirname(__FILE__), 'seeds.json')

count = 0
File.readlines(seeds_file).each do |input|
  record = JSON[input]

  product = Product.new do |p|
    p.brand = record['brand']
    p.model = record['model']
    p.cadr_dust = record['cadr_dust']
    p.aham_verified = record['aham_verified']
    p.power_max = record['power_max']
    p.noise_max = record['noise_max']
    p.made_in = record['made_in']
    p.weight = record['weight']
    p.price = record['price']
    p.air_volume = record['air_volume']
    p.fan_speed_levels = record['fan_speed_levels']
    p.sleep_mode = record['sleep_mode']
    p.timing = record['timing']
    p.quality_meter = record['quality_meter']
    p.filter_reminder = record['filter_reminder']
    p.remote_control = record['remote_control']
  end

  product.save

  count += 1
end

puts "#{count} records are imported into DB."
