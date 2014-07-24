curl "http://www.samsung.com/cn/consumer/home-appliances/air-care/viewall?sortby=popularity" |
egrep -o "href=\"/cn/consumer/home-appliances/air-care/[^\"]+" | egrep -v "reviews|dealerlocator|viewall" |
egrep -o "/cn.+" | xargs -I PATH echo http://www.samsung.com/PATH-spec
