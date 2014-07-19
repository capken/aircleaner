require 'json'

rules_dir = File.join(File.dirname(__FILE__), 'extract_rules')

@rules = {}

def extract(attr, &block)
  @rules[attr] = block
end

Dir.glob("#{rules_dir}/*.rb").each do |file|
  warn "Loading rule defined in #{file} ..."
  load file
end

STDIN.each do |line|
  input, record = JSON[line], Hash.new

  @rules.each_pair do |attr, rule|
    value = rule.call input
    record[attr] = value unless value.nil? or value == input
  end

  puts record.to_json
end
