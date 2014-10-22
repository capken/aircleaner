require "csv"
require "json"

CSV.foreach("./records.csv", :headers => true) do |row|
  brand = row['品牌']
  model = row['型号']
  filters_info = row['耗材名称；耗材型号；价格']
  filters_source = row['网址']
  filter_type = row['净化器类型']

  record = {
    :brand => brand,
    :model => model
  }

  filters = []
  if filters_info.to_s =~ /；/
    filters_info.split("\n").each do |fitler|
      f_name, f_model, f_price = fitler.split "；"
      f = { :name => f_name }
      puts f_name

      f[:model] = f_model.strip unless f_model.nil?
      f[:price] = f_price.to_f unless f_price.nil?

      filters << f
    end
  end

  unless filters_source.to_s =~ /^(?:——|\s*)$/
    filters_source = filters_source.split("\n")
    filters.each_with_index do |filter, index|
      source = filters_source[index]
      filter[:source] = source
    end
  end

  if filters.size > 0
    record['fitlers'] = filters
    #puts record.to_json
  end
end
