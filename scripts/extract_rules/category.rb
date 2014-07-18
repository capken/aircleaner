
extract :category do |input|
  input.each_pair do |label, value|
    if label =~ /类型/
      break value
    end
  end
end
