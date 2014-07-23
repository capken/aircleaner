
extract :weight do |input|
  input.each_pair do |label, value|
    if label =~ /(?:产品重量|净重|重量)/
      if value =~ /([0-9.]+)\s*g/i
        break $1.to_f/1000
      elsif value =~ /([0-9.]+)(?:kg)?/i
        break $1.to_f
      end
    end
  end
end
