
extract :material do |input|
  input.each_pair do |label, value|
    if label =~ /^(材质|机身材料|面板材质)$/
      break value
    end
  end
end
