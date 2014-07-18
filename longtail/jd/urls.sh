ruby -e "(1..11).each {|n| puts \"http://list.jd.com/list.html?cat=737%2C738%2C749&page=#{n}&delivery=1\"}" |
xargs -I URL curl URL | egrep -o "http:\/\/item\.jd\.com\/\d+\.html" | sort -u
