touch testfile
git add testfile
git commit -m "adding testfile"
git push origin main
git remote get-url origin | echo https://$(cut -d'@' -f2 | sed 's/:/\//g')commits/main/
