require 'digest/sha1' 

system "mkdir ./cache" unless Dir.exists? "./cache"

encode = ARGV[0]

STDIN.each do |url|
  url = url.strip
  hash = Digest::SHA1.hexdigest(url)
  warn "caching #{url} into ./cache/#{hash} ..."

  if encode
    system "curl -L #{url} | iconv -f #{encode} -t utf-8 > ./cache/#{hash}"
  else
    system "curl -L #{url} > ./cache/#{hash}"
  end
end
