
refine do |record|
  color = record['color']
  next if color.nil?
  color = color.gsub(/[，\/和+-]/, ',')
  record['color'] = color
end
