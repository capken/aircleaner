ruby -e "(1..25).each {|n| puts \"http://www.amazon.cn/s/?rh=n%3A814224051%2Cn%3A814229051%2Cn%3A814275051%2Cp_n_fulfilled_by_amazon%3A326314071&page=#{n}\"}" |
xargs -I URL curl -L URL | egrep -o "\/dp\/[A-Z0-9]+" | sort -u | xargs -I ID echo "http://www.amazon.cnID"
