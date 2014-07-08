ruby -e "(1..20).each {|n| puts \"http://list.jd.com/737-738-749-0-3207-0-0-0-0-0-1-1-#{n}-1-2-2811-2857-0.html\"}" |
xargs -I URL curl URL | egrep -o "http:\/\/item\.jd\.com\/\d+\.html" | sort -u
