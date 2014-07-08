ruby -e "(1..33).each { |n| puts \"http://product.yesky.com/kqjhq/list#{n}.html\"}" | 
xargs -I URL curl URL |
egrep -o "product\/[0-9.]+\/\d+" | sort -u | ruby -ne "puts \$_.gsub(/\.0/, '')" | sort -u |
xargs -I PATH echo "http://product.yesky.com/PATH/param.shtml" | egrep -v "\d{8}"
