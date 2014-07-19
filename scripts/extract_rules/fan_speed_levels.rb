
extract :fan_speed_levels do |input|
  input.each_pair do |label, value|
    if label =~ /风速|风量/

      levels = if value =~ /([2-9]+)[级档]/
        $1.to_i
      elsif value =~ /([二三四五六])[级档]/
        "二三四五六".index($1) + 2
      else
        value.split('、').size
      end

      if levels > 1
        break levels
      end
    end
  end
end
