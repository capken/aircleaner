
refine do |record|
  made_in = record['made_in']
  next if made_in.to_s.empty?

  if made_in =~ /(台湾|加拿大|墨西哥|捷克|泰国|瑞士|瑞典|美国|荷兰|韩国|香港|德国)/
    made_in = $1
  else
    made_in = '中国'
  end

  record['made_in'] = made_in
end
