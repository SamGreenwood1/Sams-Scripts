for p in $(xargs < ~/sites.txt);
do
    mkdir -p $(dirname ${p})
done
