xargs -I DIR bash -c "(cd DIR; cat urls.txt | ruby extract.rb)" > official_new.json
