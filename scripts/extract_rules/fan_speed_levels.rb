
extract :fan_speed_levels do |input|
  input.each_pair do |label, value|
    if label =~ /风速设定/
      if value =~ /(\d+)级风速/
        break $1.to_i
      end
    end
  end
end
