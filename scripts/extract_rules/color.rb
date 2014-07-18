
extract :color do |input|
  input.each_pair do |label, value|
    if label =~ /外观/
      break value
    end
  end
end
