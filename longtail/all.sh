ls -l | egrep '^d' | awk "{print \$9}" |
xargs -I DIR bash -c '(cd DIR && cat urls.txt | ruby extract.rb)' > all.json

