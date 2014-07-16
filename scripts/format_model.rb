require "json"

STDIN.each do |line|
  record = JSON[line]

  model = record['model']
  model = model.gsub(/[^0-9a-zA-Z \/-]/, ' ').
    gsub(/\s+/, ' ').strip

  case record['brand']
  when /^3M$/
    model = model.gsub(/- CN/i, '-CN')
  when /^IQAir$/
    model = model
      .gsub(/HealthPro\s*/, 'HealthPro ')
      .gsub(/(?:IQAir|Allergen)\s*/i, '')
  when /^SKG$/
    model = model
      .gsub(/^SKG/, '')
  when /^cado$/
    record['color_tag'] = $1 if model =~ /-([A-Z]{2})$/
    model = model
      .gsub(/Cado\s*/i, '')
      .gsub(/^(C\d+)/, 'AP-\1')
      .gsub(/-[A-Z]{2}$/, '')
  when /^亚都$/
    model = model
      .gsub(/-(\d{4})$/, '\1')
      .gsub(/-TGS/, '')
  when /^夏普$/
    record['color_tag'] = $1 if model =~ /-([A-Z\/]{1,3})$/
    model  = model.gsub(/-[A-Z\/]{1,3}$/, '')
  when /^大金$/
    record['color_tag'] = $1 if model =~ /-([A-Z])$/
    model  = model.gsub(/\s*-\s*[A-Z]$/, '')
  when /^奥司汀$/
    model = model
      .gsub(/-(\d+)$/, '\1')
      .gsub(/Allergy Machine\s*/, '')
  when /^奥郎格$/
    model = model.gsub(/Airgle\s*/, '')
  when /^布鲁雅尔$/
    model = model.gsub(/^AV/, '')
    case model
    when /403|410B/
      model = "403;410B"
    when /503|510B/
      model = "503;510B"
    end
  when /^汇清$/
    model = model.gsub /-[A-Z]{2}/, ''
  when /^松下$/
    record['color_tag'] = $1 if model =~ /[- ]([A-Z](?:\/[A-Z])*)$/
    model = model.gsub(/[- ][A-Z](?:\/[A-Z])*$/, '')
  when /瑞士风/
    model = model.gsub(/^AOS\s*/, "")
  when /霍尼韦尔/
    model = model.gsub(/(?:-CHN|APCN)$/, '')
  when /飞利浦/
    model = model.upcase.gsub(/SET$/, '')
  end
  
  #puts "#{record['brand']}\t#{record['model']}\t#{model}\t#{record['color_tag']}"
  record['model'] = model
  puts record.to_json
end
