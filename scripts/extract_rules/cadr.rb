
extract :cadr_dust do |input|
  input.each_pair do |label, value|
    if label =~ /洁净空气(?:输出)?量|CADR|净化空气率|过滤微粒/i
      cadr = case value
      when /([\d.]+)\s*(?:m3\/h|CMH|m\?\/h|平米每小时|m³\/h|每小时立方米)/i
        $1.to_i
      when /^([\d.]+)(?:以内)?$/i
        $1.to_i
      when /^([\d.]+)至([\d.]+)$/i
        $2.to_i
      when /CADR值([\d.]+)\(m\?\/h\)/i
        $1.to_i
      end

      cadr = nil if cadr.to_s =~ /^(99|98)$/

      #warn "#{value} => [#{cadr}] => #{input['_source']}"

      break cadr
    end
  end
end
