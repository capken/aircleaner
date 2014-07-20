
extract :brand do |input|
  input['品牌'] || input['brand']
end

extract :model do |input|
  input['型号'] || input['model']
end

extract :price do |input|
  price = input['price'] || input['产品价格']
  price.gsub(/￥/, '').to_i if price
end

extract :_source do |input|
  input['_source']
end
