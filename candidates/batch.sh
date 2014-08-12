cat data/longtail.0723.json data/official_new.json | ruby ../scripts/extract.rb > data/tmp
cat data/tmp data/manual.0723.json data/manual.0812.json data/aham.0720.json data/official.0720.json |
ruby ../scripts/refine.rb| sort | tee refined.json |
egrep -f ./candidates.txt |
ruby ../scripts/merge.rb | tee merged.json |
ruby ../scripts/summarize.rb | tee summarized.json |
ruby ../scripts/json2csv.rb > summarized.csv
