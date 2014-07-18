
extract :power do |input|
  input.each_pair do |label, value|
    if label =~ /^功率$/
      max = $1.to_i if value =~ /(?:强力)\s*(\d+)W/i
      min = $1.to_i if value =~ /(?:静音)\s*(\d+)W/i

      power = {}
      power['min'] = min if min
      power['max'] = max if max

      break power
    end
  end
end
