# Save the output of each command to separate files
ls */* | grep public > ls_output.txt
tree ~/sites/ -L 2 -C > tree_output.txt

# Display the output side by side using the paste command
paste ls_output.txt tree_output.txt
