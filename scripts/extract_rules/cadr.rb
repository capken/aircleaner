
extract :cadr_dust do |input|
  input.each_pair do |label, value|
    if label =~ /洁净空气(?:输出)?量|CADR/i
      if value =~ /^(\d+)\s*(?:m3\/h)/
        break $1.to_i
      end
    end
  end
end
