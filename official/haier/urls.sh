curl "http://www.haier.com/cn/consumer/air_conditioners/aircleaner/" | egrep -o "20\d+\/t[0-9_]+\.shtml" | sort -u |
xargs -I PATH echo "http://www.haier.com/cn/consumer/air_conditioners/aircleaner/PATH"
