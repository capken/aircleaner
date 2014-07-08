ruby -e "(0..15).each { |n| puts \"http://list.suning.com/0-20394-#{n}-1-0-9017-0-0-0-0-22478-22475.html\"}" |
xargs -I URL curl URL | egrep -o "http:\/\/product\.suning\.com\/\d+\.html" | sort -u
