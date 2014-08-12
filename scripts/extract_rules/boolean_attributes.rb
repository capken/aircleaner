
def boolean_of(value)
  if value =~ /^(?:支持|有|是|●)/
    true
  elsif value =~ /^(?:不支持|无|否|-)/
    false
  end
end

extract :sleep_mode do |input|
  input.each_pair do |label, value|
    if label =~ /^睡眠模式$/
      break boolean_of(value)
    end
  end
end

extract :remote_control do |input|
  input.each_pair do |label, value|
    if label =~ /^(?:遥控|带遥控器)$/
      break boolean_of(value)
    end
  end
end

extract :timing do |input|
  input.each_pair do |label, value|
    if label =~ /^定时(?:功能|模式)$/
      break boolean_of(value)
    end
  end
end

extract :quality_meter do |input|
  input.each_pair do |label, value|
    if label =~ /^(?:空气质量(?:指示灯|提示|显示功能)|净化度指示灯|空气污染指示灯)$/
      break boolean_of(value)
    end
  end
end

extract :filter_reminder do |input|
  input.each_pair do |label, value|
    if label =~ /^(?:过?滤网)(?:更新|更换)提醒(?:功能)?$/
      break boolean_of(value)
    end
  end
end

