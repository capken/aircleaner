
refine do |record|
  @is_good_record = 
    record['category'].to_s =~ /耗材/ ? false : true
end
