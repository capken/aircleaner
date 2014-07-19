
extract :cadr_dust do |input|
  input.each_pair do |label, value|
    if label =~ /洁净空气(?:输出)?量|CADR|净化空气率|过滤微粒/i
      cadr = {}
      case value
      when /([\d.]+)\s*(?:m3\/h|CMH)/i
        cadr['dust'] = $1.to_i
      when /CADR值([\d.]+)\(m\?\/h\)/i
        cadr['dust'] = $1.to_i
      end
      break cadr
    end
  end
end
