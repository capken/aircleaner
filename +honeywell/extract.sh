#!/bin/bash 

cat `dirname $0`/urls.txt | ruby `dirname $0`/../jd/jd_common.rb `dirname $0`/rule.yaml
