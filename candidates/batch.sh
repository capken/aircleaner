cat data/longtail.0814.json data/official_new.json | ruby ../scripts/extract.rb > data/tmp
cat data/tmp data/manual.0723.json data/manual.0812.json data/products.with.append.images.json data/aham.0720.json data/official.0720.json |
ruby ../scripts/refine.rb| sort | tee refined.json |
egrep -f ./candidates.txt |
ruby ../scripts/merge.rb | tee merged.json |
ruby ../scripts/summarize.rb | tee summarized.json |
ruby ../scripts/json2csv.rb > summarized.csv

cat summarized.json | ruby -rjson -ne "images = JSON[\$_]['image']; puts images.split(',') if images" > image_urls.txt
