curl "http://www.lg.com/cn/air-purifier/view-all" | 
egrep -o "cn\/air-purifier\/lg-.+?-air-purifier" | sort -u |
xargs -I URL echo "http://www.lg.com/URL"
