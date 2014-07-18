
extract :air_volume do |input|
  input.each_pair do |label, value|
    if label =~ /^(?:风量)$/i
      if value =~ /^(\d+)\s*(?:m3\/h)/
        break $1.to_i
      end
    end
  end
end
