require 'csv'
require 'json'

is_first_line = true
csv_string = CSV.generate do |csv|
  STDIN.each do |line|
    json = JSON.parse(line)
    if is_first_line
      is_first_line = false
      csv << json.keys
    end
    csv << json.values.map { |v| v.strip }
  end
end

puts csv_string
