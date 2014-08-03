curl "http://consumer.panasonic.cn/product/home-living/air-purifier-dehumidifier.html" |
egrep -o "air-purifier\/.+?\.html" | sort -u |
xargs -I PATH echo "http://consumer.panasonic.cn/product/home-living/air-purifier-dehumidifier/PATH"
