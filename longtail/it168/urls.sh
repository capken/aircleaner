ruby -e "(1..11).each { |n| puts \"http://product.it168.com/list/b/0162_#{n}.shtml\" }" |
xargs -I URL ruby ~/codes/tor_spider/script/tools/mechanize.rb URL 'detail\/doc\/\d+\/index\.shtml' |
cut -f 3 | sort -u | ruby -ne "puts \$_.gsub(/index/, 'detail')"
