require 'json'

path = File.join(File.dirname(__FILE__), "attr_meta.json")
attr_meta = JSON[File.readlines(path).join]

def value_of(record, name, type)
  raw_value = (name =~ /^(.+?):(.+?)$/) ? 
    (record[$1] && record[$1][$2]) : record[name]

  return nil if raw_value.nil?

  value = case type.to_sym
  when :float
    raw_value.to_s =~ /-1/ ? nil : raw_value.to_f
  when :integer
    raw_value.to_s =~ /-1/ ? nil : raw_value.to_i
  when :string
    raw_value.to_s
  when :boolean
    (raw_value.to_s =~ /^(?:true|支持|有)$/i) ? true : false
  end

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
    attr_meta.each do |attr, meta|
      record[attr] = [] if meta['summary_mode']
    end
  end

  attr_meta.each do |attr, meta|
    next if meta['summary_mode'].nil?
    value = value_of(cr, meta['name'], meta['type'])
    merge(record[attr], value, cr['_source'])
  end

  pr = cr
end

puts record.to_json
