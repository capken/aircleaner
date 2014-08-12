
extract :color do |input|
  input.each_pair do |label, value|
    if label =~ /^外观$|颜色|基本规格/
      break value
    end
  end
end
