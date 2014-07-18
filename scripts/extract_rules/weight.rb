
extract :weight do |input|
  input.each_pair do |label, value|
    if label =~ /^(?:产品重量|净重（kg\))$/
      if value =~ /([0-9.]+)(?:kg)?/i
        break $1.to_f
      end
    end
  end
end
