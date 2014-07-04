curl "http://www.philips.com.cn/c/%E7%A9%BA%E6%B0%94%E5%87%80%E5%8C%96%E5%99%A8/air-purifier-acp077_00/prd/" |
egrep -o "http://www.philips.com.cn/c/空气净化器/[^;\"]+?prd" | sort -u
