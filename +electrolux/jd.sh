#!/bin/bash 

`dirname $0`/extract.sh | 
ruby -rjson -ne "record = JSON[\$_]; puts record['brand'] + '%20' + record['model']" | 
xargs -I KEY_WORD curl "http://search.jd.com/Search?keyword=KEY_WORD" | 
egrep -o "http://item.jd.com/\d+\.html" | sort -u
