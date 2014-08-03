ruby -e "(1..4).each {|i| puts 'http://www.yadu.com.cn/index.php?m=default.product&classid=7&PB_page=' + i.to_s}" | 
xargs -I URL curl URL | egrep -o "classid=\d+&id=\d+" | sort -u |
xargs -I ID echo "http://www.yadu.com.cn/index.php?m=default.product_detail&ID"
