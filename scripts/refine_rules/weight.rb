
refine do |record|
  weight = record['weight']
  if weight
    if weight < 0.5
      @is_good_record = false
    elsif weight > 100
      record['weight'] = weight / 100.0
    end
  end
end
