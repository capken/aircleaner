curl "http://www.whirlpool.com.cn/product/list.aspx?bigclass=362539770003324928" | 
egrep -o "detail.aspx\?id=3\d+" | sort -u | xargs -I ID echo "http://www.whirlpool.com.cn/product/ID"
