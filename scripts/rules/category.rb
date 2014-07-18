
refine do |record|
  @is_good_record = 
    record['category'].to_s =~ /滤网|耗材|附件|滤芯|喷香机/ ? false : true
end
