
extract :noise_level do |input|
  input.each_pair do |label, value|
    if label =~ /噪音/

      case value
      when /^(?:《|≤|＜|小于|小于等于|少于|低于)?([0-9.]+)(?:dB|dB以下|分贝|db\(A\))?$/i
        max = $1.to_f
      when /([0-9.]+).*?[-~].*?([0-9.]+)/
        min = $1.to_f
        max = $2.to_f
      else
        min = $1.to_f if value =~ /(?:静音|低)[：\s]*([0-9.]+)/
        max = $1.to_f if value =~ /(?:强力|高)[：\s]*([0-9.]+)/
      end

      noise = {}
      noise['min'] = min if min
      noise['max'] = max if max

      break noise
    end
  end
end
