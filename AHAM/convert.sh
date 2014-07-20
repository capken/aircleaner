cat aham_raw.json | 
ruby -rjson -ne "

j = JSON[\$_]; r = {}
['brand', 'model'].each { |p| r[p] = j[p]}
raw_cadr = j['cadr_dust'].gsub(/^[<>]\s*/, '').gsub(/(?:WAS|\\+).+$/, '').strip if j['cadr_dust']
r['cadr_dust'] = raw_cadr;
r['_source'] = 'http://www.ahamdir.com';
puts r.to_json

" | sort -u
