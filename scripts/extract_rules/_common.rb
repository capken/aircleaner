
extract :brand do |input|
  input['brand']
end

extract :model do |input|
  input['model']
end

extract :price do |input|
  input['price']
end

extract :_source do |input|
  input['_source']
end
