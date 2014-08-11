curl "http://www.midea.com/cn/Household_Products/cleaner/index2.shtml" |
egrep -o "jsq.+?shtml" | xargs -I PATH echo "http://www.midea.com/cn/Household_Products/cleaner/PATH" |
sort -u
