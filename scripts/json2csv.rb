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
      csv << attr_meta.values.map { |meta| meta['label'] }
    end

    csv << attr_meta.keys.map do |attr|
      record[attr].nil? ? "" : record[attr]
    end
  end
end

puts csv_string
