
extract :model do |input|
  input['型号'] || input['model']
end
