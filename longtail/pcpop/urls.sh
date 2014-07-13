ruby -e "(1..11).each { |n| puts \"http://product.pcpop.com/purifier/00000_#{n}.html\"}" |
xargs -I URL curl URL | iconv -f GBK -t utf-8 | ruby -ne "puts \$_.gsub('<li', \"\n<li\")" | 
egrep -o "http:\/\/product\.pcpop\.com\/\d+" | sort -u |
xargs -I URL echo "URL/Detail.html"
