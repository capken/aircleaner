#!/bin/bash 

ruby -rjson -ne "record = JSON[\$_]; puts record['brand'] + '%20' + record['model']" > keywords.txt

cat keywords.txt |
xargs -I KEY_WORD curl "http://search.jd.com/Search?keyword=KEY_WORD" | 
egrep -o "http://item.jd.com/\d+\.html" | sort -u > jd.urls.txt

#cat keywords.txt |
#xargs -I KEY_WORD curl "http://search.yesky.com/searchproduct.do?wd=KEY_WORD" |
#egrep -o "product\/[0-9.]+\/\d+" | sort -u | ruby -ne "puts \$_.gsub(/\.0/, '')" |
#xargs -I URL echo "http://product.yesky.com/URL/param.shtml" > yesky.urls.txt

cat keywords.txt | 
xargs -I KEY_WORD curl "http://detail.zol.com.cn/index.php?c=SearchList&keyword=KEY_WORD" |
egrep -o "purifier\/index\d+\.shtml" | sort -u |
xargs -I PATH curl "http://detail.zol.com.cn/PATH" |
egrep -o "\/\d+\/\d+/param\.shtml" | sort -u | xargs -I PATH echo "http://detail.zol.com.cn/PATH" > zol.urls.txt
