cat AHAM_Verifide_Models.json | 
ruby -rjson -ne "

j = JSON[\$_]; r = {}
['brand', 'model'].each { |p| r[p] = j[p]}
raw_cadr = j['dust_cadr'].gsub(/^[<>]\s*/, '').gsub(/(?:WAS|\\+).+$/, '').strip
r['CADR'] ={ 'dust' => raw_cadr };
r['_source'] = 'http://www.ahamdir.com';
puts r.to_json

" | sort -u
