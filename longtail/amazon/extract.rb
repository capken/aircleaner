require "nokogiri"
require "json"
require "uri"
require 'digest/sha1' 

STDIN.each do |url|
  url = url.strip
  warn "\nprocessing page => #{url} ...\n"

  hash = Digest::SHA1.hexdigest(url)
  cached_file = File.open "./cache/#{hash}"
  content = cached_file.read

  input = {}

  doc = Nokogiri::HTML(content)
  doc.css("a#brand").each do |brand|
    input["brand"] = brand.to_str
  end

  doc.css('div#detail_bullets_id li').each do |li|
    if li.to_str =~ /(.+?):(.+)/m
      next if $1.include? '用户评分'
      input[$1.strip] = $2.strip
    end
  end
  doc.css("div#imgTagWrapperId img").each do |image|
    input["image"] = URI.join url.strip, image["src"]
  end
  doc.css("span#priceblock_ourprice").each do |price|
    input["price"] = price.to_str
  end

  if content =~ /iframeContent = "(.+?)"/
    html = URI.decode $1
    doc = Nokogiri::HTML(html)
  
    doc.css("div.goods_parameter table tr").each do |tr|
      tds = tr.css("td")
      (1..tds.size/2).each do |i|
        input[tds[2*i-2].to_str] = tds[2*i-1].to_str
      end
    end

    doc.css("div.productDescriptionWrapper").each do |div|
      div.to_xml.split("<br\/>").each do |line|
        if line =~ /(.+?)：(.+)/
          key, value = $1, $2
          key = key.gsub(/<.+?>/, '').strip
          value = value.gsub(/<.+?>/, '').strip
          next if key.size > 30 or value.size > 30
          input[key] = value
        end
      end
    end

  end

  input["reviews_link"] = url.sub(/dp/, "product-reviews")

  input["_source"] = url
  puts input.to_json
end
