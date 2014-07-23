require "csv"
require "json"

path = File.join(File.dirname(__FILE__), "attr_meta.json")
attr_meta = JSON[File.readlines(path).join]

mapping = {}
attr_meta.each do |attr, meta|
  mapping[meta['label']] = attr
end

CSV.foreach(ARGV[0], :headers => true) do |row|
  record = {}
  mapping.each do |label, attr|
    if row[label]
      value = case attr_meta[attr]['type']
      when 'string'
        row[label]
      when 'boolean'
        if row[label].to_s =~ /true/i
          true
        elsif row[label].to_s =~ /false/i
          false
        end
      when 'integer'
        row[label].to_i
      when 'float'
        row[label].to_f
      end

      record[attr] = value
    end
  end

  record['_source'] = row['数据来源']

  puts record.to_json
end
