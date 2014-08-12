
extract :noise_level do |input|
  noise = {}

  input.each_pair do |label, value|
    case label
    when /低风噪音/
      noise['min'] = value.to_f
    when /高风噪音/
      noise['max'] = value.to_f
    when /噪音|噪声/
      case value
      when /^(?:[﹤＜<≤《]|小于|小于等于|少于|低于|≤dB)?([0-9.]+)(?:\(db\)|dB|dba|dB\s*以下|分贝|（A）|db\(A\)|dB（A）)?\s*(?:\(声压）)?\s*$/i
        max = $1.to_f
      when /([0-9.]+).*?[\/~－-].*?([0-9.]+)/
        min = $1.to_f
        max = $2.to_f
      else
        min = $1.to_f if value =~ /(?:静音档?|低速?|弱|睡眠|宁静|最低噪音)(?:[：:\/\s]|≤|低于)*([0-9.]+)/ or
          value =~ /([\d.]+)[（(](?:静音档?|低风|宁静|休眠|睡眠|弱|低速?|最低噪音|安静)/
        max = $1.to_f if value =~ /(?:强力|高|强|最大|[急极]速档?|最?高速|最大风速)(?:[：:\/\s]|≤|低于)*([0-9.]+)/ or
          value =~ /([\d.]+)[（(](?:强档?|高风?|[急极]速档?|最?高速|最[大高]风速|特级强风)/
      end

      noise['min'] = min if min
      noise['max'] = max if max
    end
  end

  noise.empty? ? nil : noise
end
