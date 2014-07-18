require 'csv'
require 'json'

headers = {
  "brand" => "品牌",
  "model" => "型号",
  "CADR:dust" => "CADR 灰尘(m3/h)",
  "CADR:pollen" => "CADR 花粉",
  "CADR:tobacco_smoke" => "CADR 烟雾",
  "dimensions:height" => "高度(mm)",
  "dimensions:width" => "宽度(mm)",
  "dimensions:deep" => "深度(mm)",
  "weight" => "重量(kg)",
  "color" => "颜色",
  "noise_level:min" => "最小噪音(dB)",
  "noise_level:max" => "最大噪音(dB)",
  "power:min" => "最小功率(W)",
  "power:max" => "最大功率(W)",
  "air_volume" => "最大风量",
  "material" => "材料",
  "made_in" => "原产地",
  "filter_lifetime" => "滤网寿命",
  "filter_material" => "滤网材料",
  "filter_replacement_reminder" => "滤网更新提醒",
  "sleep_mode" => "支持睡眠模式",
  "remote_control" => "支持遥控",
  "timing" => "支持定时",
  "air_quality_led" => "空气质量显示",
  "total_fan_speed_levels" => "风档",
  "image" => "图片",
  "_source" => "数据来源"
}

is_first_line = true
csv_string = CSV.generate(:encoding => "utf-8") do |csv|
  STDIN.each do |line|

    if is_first_line
      is_first_line = false
      csv << headers.values
    end

    record = JSON.parse(line)
    row = []
    headers.keys.each do |header|
      if header =~ /^(.+?):(.+?)$/
        detail = record[$1] || {}
        row << detail[$2]
      else
        row << record[header]
      end
    end

    csv << row
  end
end

puts csv_string
