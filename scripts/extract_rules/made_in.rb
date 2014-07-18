
extract :made_in do |input|
  input.each_pair do |label, value|
    if label =~ /^产地$/
      break value
    end
  end
end
