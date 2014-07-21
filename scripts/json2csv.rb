require 'csv'
require 'json'

path = File.join(File.dirname(__FILE__), "attr_meta.json")
attr_meta = JSON[File.readlines(path).join]

is_first_line = true
csv_string = CSV.generate do |csv|
  STDIN.each do |line|
    record = JSON.parse(line)
    if is_first_line
      is_first_line = false
      csv << ['brand', 'model'].concat(attr_meta.keys)
    end

    attrs = [record['brand'], record['model']]
    attr_meta.keys.each do |attr|
      attrs << record[attr] ? record[attr] : ''
    end

    csv << attrs
  end
end

puts csv_string
