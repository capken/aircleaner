cat seed_domains.txt | xargs -I DIR bash -c '(cd DIR && cat urls.txt | ruby extract.rb)' > result.json
