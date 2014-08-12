require "nokogiri"
require "json"
require "uri"
require 'digest/sha1' 

STDIN.each do |url|
  url = url.strip
  warn "\nprocessing page => #{url} ...\n"
  hash = Digest::SHA1.hexdigest(url)
  cached_file = File.open "./cache/#{hash}"

  doc = Nokogiri::HTML(cached_file.read)

  input = {}
  input["brand"] = "LG"

  doc.css("h4").each do |h|
    input["model"] = h.to_str
  end

  doc.css("div.accordion-item").each do |div|
    uls = div.css("ul")

    labels = uls.first.css('li')
    values = uls.last.css('li')
    if labels.size == values.size
      labels.each_with_index do |label, i|
        input[label.to_str] = values[i].to_str
      end
    end
  end

  input["_source"] = url

  puts input.to_json
end
