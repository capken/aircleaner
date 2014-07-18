cat data/*.json |
ruby ../scripts/refine.rb | sort -u | tee refined.json |
ruby ../scripts/merge.rb | tee merged.json |
ruby ../scripts/summarize.rb > summarized.json

