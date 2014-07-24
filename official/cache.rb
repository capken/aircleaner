ls -la | egrep -o "\+[a-z]+" | egrep -o "[a-z]+" | xargs -I DIR bash -c "(cd +DIR; cat urls.txt | ruby ../../scripts/crawl.rb)"
