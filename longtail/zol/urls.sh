ruby -e "(1..14).each { |n| puts \"http://detail.zol.com.cn/purifier/#{n}.html\" }" | 
xargs -I URL curl URL | egrep -o "purifier\/index\d+\.shtml" | sort -u |
xargs -I PATH curl "http://detail.zol.com.cn/PATH" |
egrep -o "\/\d+\/\d+/param\.shtml" | sort -u | xargs -I PATH echo "http://detail.zol.com.cn/PATH"
