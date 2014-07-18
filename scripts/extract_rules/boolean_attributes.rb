
def boolean_of(value)
  if value =~ /^(?:支持)/
    true
  elsif value =~ /^(?:不支持)/
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
    if label =~ /^遥控$/
      break boolean_of(value)
    end
  end
end

extract :timing do |input|
  input.each_pair do |label, value|
    if label =~ /^定时功能$/
      break boolean_of(value)
    end
  end
end

extract :quality_meter do |input|
  input.each_pair do |label, value|
    if label =~ /^空气质量指示灯$/
      break boolean_of(value)
    end
  end
end

extract :filter_reminder do |input|
  input.each_pair do |label, value|
    if label =~ /^滤网更新提醒$/
      break boolean_of(value)
    end
  end
end

