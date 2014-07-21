
extract :category do |input|
  input.each_pair do |label, value|
    if label =~ /类型/
      break (value =~ /滤网$|^附件|(?:附件|耗材)$/) ? "耗材" : value
    elsif label =~ /model|型号/
      if value =~ /滤网$|^附件|附件$/
        break "耗材"
      end
    end
  end
end
