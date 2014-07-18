
extract :noise_level do |input|
  input.each_pair do |label, value|
    if label =~ /^噪音$/
      max = $1.to_i if value =~ /(?:强力)\s*(\d+)dB/i
      min = $1.to_i if value =~ /(?:静音)\s*(\d+)dB/i

      noise = {}
      noise['min'] = min if min
      noise['max'] = max if max

      break noise
    end
  end
end
