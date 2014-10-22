
refine do |record|
  if record['image']
    if record['_source'] =~ /zol/
      record['image'] = nil
    end
  end
end
