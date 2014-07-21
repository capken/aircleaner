
extract :brand do |input|
  input['品牌'] || input['brand']
end

