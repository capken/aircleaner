
extract :material do |input|
  input.each_pair do |label, value|
    if label =~ /^(材质|机身材料)$/
      break value
    end
  end
end
