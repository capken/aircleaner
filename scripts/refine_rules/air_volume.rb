
refine do |record|
  if record['air_volume'] and record['air_volume'] > 5000
    record['air_volume'] = nil
  end
end
