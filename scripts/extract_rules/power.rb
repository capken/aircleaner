
extract :power do |input|
  input.each_pair do |label, value|
    if label =~ /^(?:功率|额定功率\(w\))$/i

      case value
      when /^([\d.]+)\s*(?:w|瓦特|瓦)?$/i
        max = $1.to_f
      when /([\d.]+)W?[~\/-]([\d.]+)W?/i
        min = $1.to_f
        max = $2.to_f
      else
        max = $1.to_f if value =~ /(?:强力)\s*([\d.]+)W/i
        min = $1.to_f if value =~ /(?:静音)\s*([\d.]+)W/i
      end

      power = {}
      power['min'] = min if min
      power['max'] = max if max

      break power
    end
  end
end
