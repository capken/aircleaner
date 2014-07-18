
extract :filter_life do |input|
  input.each_pair do |label, value|
    if label =~ /滤网使用寿命/
      break value
    end
  end
end
