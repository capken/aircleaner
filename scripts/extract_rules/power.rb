
extract :power do |input|
  input.each_pair do |label, value|
    if label =~ /^功率|额定功率/i
      case value
      when /^(?:小于|最大)?\s*([\d.]+)\s*(?:w|瓦特|瓦)?$/i
        max = $1.to_f
      when /([\d.]+)W?[~\/-]([\d.]+)W?/i
        ps = [$1, $2].map(&:to_f).sort
        min, max  = ps.first, ps.last
      when /([\d.]+)\/[\d.]+\/([\d.]+)/
        ps = [$1, $2].map(&:to_f).sort
        min, max  = ps.first, ps.last
      else
        max = $1.to_f if value =~ /(?:强力|最高|急|高|强|高速)[：:\s\/]*([\d.]+)W/i
        min = $1.to_f if value =~ /(?:静音|最小|低|弱|低速)[：:\s\/]*([\d.]+)W/i
      end

      power = {}
      power['min'] = min if min
      power['max'] = max if max

      break power
    end
  end
end
