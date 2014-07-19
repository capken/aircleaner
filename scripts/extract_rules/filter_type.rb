
extract :filter_type do |input|
  input.each_pair do |label, value|
    if label =~ /过滤网材质/
      break value
    end
  end
end
