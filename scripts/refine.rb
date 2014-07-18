require 'json'

rules_dir = File.join(File.dirname(__FILE__), 'rules')

@rules = []

def refine(&block)
  @rules << block
end

Dir.glob("#{rules_dir}/*.rb").each do |file|
  warn "Loading rule defined in #{file} ..."
  load file
end

STDIN.each do |line|
  record = JSON[line]
  @is_good_record = true
  @rules.each do |rule|
    rule.call record
    break unless @is_good_record
  end

  puts record.to_json if @is_good_record
end

