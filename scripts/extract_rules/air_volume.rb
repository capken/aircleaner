
extract :air_volume do |input|
  input.each_pair do |label, value|
    if label =~ /^(?:风量|额定风量|最大风速)(?:（m3\/h\）)?$/i
      if value =~ /^([\d.]+)\s*(?:m3\/h|[m³|㎡]\/h|每小时立方米|立方米?\/小?[时h])?$/i
        break $1.to_i
      end
    end
  end
end
