
refine do |record|
  if record['cadr_dust']
    if record['_source'] =~ /ahamdir\.com/
      record['aham_verified'] = true
    else
      record['aham_verified'] = false
    end
  end
end
