
extract :price do |input|
  price = input['price'] || input['产品价格']
  price.gsub(/[￥,]/, '').to_f if price
end

extract :_source do |input|
  input['_source']
end
