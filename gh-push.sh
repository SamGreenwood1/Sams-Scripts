search=$(history 1 | tail -2 | head -1 | cut -c 21-)
echo system $search
git add $search
echo WHat do you want you commit message to be?
read
git commit -m $REPLY
git push
