curl "http://www.newegg.cn/SubCategory/841.htm?pageSize=96" |
egrep -o "Product\/[0-9A-Z-]+\.htm" | xargs -I PATH echo "http://www.newegg.cn/PATH" | sort -u
