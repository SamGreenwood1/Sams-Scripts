echo Enter name of alias:
read
name=$REPLY
echo Enter command :
read
command=$REPLY
echo "alias $name='$command'" >> ~/.bashrc
