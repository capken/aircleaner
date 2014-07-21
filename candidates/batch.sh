cat data/longtail.0720.json | ruby ../scripts/extract.rb > data/tmp
cat data/tmp data/aham.0720.json data/official.0720.json |
ruby ../scripts/refine.rb| sort | tee refined.json |
egrep -f ./candidates.txt |
ruby ../scripts/merge.rb | tee merged.json |
ruby ../scripts/summarize.rb > summarized.json
