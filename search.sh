search=$(history 1 | tail -2 | head -1 | cut -c 20-)
os=$(uname -r)

echo output $os
echo search $search

if [ os="MANJARO" ]
     then
	yay -Ss $search


elif [ os="UBUNTU" ]
     then 
     apt search $search
fi

snap find $search
