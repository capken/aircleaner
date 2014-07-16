require 'json'

attr_mapping = {
  "cadr_dust" => { :name => "CADR:dust",  :type => :integer },
  "power_min" => { :name => "power:min",  :type => :float },
  "power_max" => { :name => "power:max",  :type => :float },
  "noise_min" => { :name => "noise_level:min",  :type => :float },
  "noise_max" => { :name => "noise_level:max",  :type => :float },
  "made_in" => { :name => "made_in", :type => :string },
  "weight" => { :name => "weight",  :type => :float },
  "color" => { :name => "color",  :type => :string },
  "sleep_mode" => { :name => "sleep_mode",  :type => :boolean },
  "remote_control" => { :name => "remote_control",  :type => :boolean },
  "timing" => { :name => "timing",  :type => :boolean },
  "quality_meter" => { :name => "air_quality_led",  :type => :boolean },
  "filter_reminder" => { :name => "filter_replacement_reminder",  :type => :boolean },
  "filter_life" => { :name => "filter_lifetime",  :type => :float },
}

def value_of(record, name, type)
  raw_value = (name =~ /^(.+?):(.+?)$/) ? 
    (record[$1] && record[$1][$2]) : record[name]

  value = case type 
  when :float
    raw_value.to_s =~ /-1/ ? nil : raw_value.to_f
  when :integer
    raw_value.to_s =~ /-1/ ? nil : raw_value.to_i
  when :string
    raw_value.to_s
  when :boolean
    (raw_value.to_s =~ /^(?:true|支持|有)$/i) ? true : false
  end if raw_value

  return value
end

def merge(votes, value, source)
  return if value.nil?

  matched_vote = votes.select do |vote| 
    vote['value'] == value
  end.first

  if matched_vote
    matched_vote['source'] << source
  else
    votes << { 'value' => value, 'source' => [source] } 
  end
end

pr, record = nil, nil
STDIN.each do |line|
  cr = JSON[line]

  puts record.to_json if pr and pr['model'] != cr['model']

  if pr.nil? or pr['model'] != cr['model']
    record = {
      'brand' => cr['brand'],
      'model' => cr['model']
    }
    attr_mapping.keys.each { |attr| record[attr] = [] }
  end

  attr_mapping.each do |attr, meta|
    value = value_of(cr, meta[:name], meta[:type])
    merge(record[attr], value, cr['_source'])
  end

  pr = cr
end

puts record.to_json
