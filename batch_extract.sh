ls | grep "+" | xargs -I FOLDER bash -c "./FOLDER/extract.sh" > result.json
