#!/bin/bash

# Function to remove aliases
remove_aliases() {
    local alias_name="$1"
    sed -i "/alias $alias_name=/d" "$HOME/.bashrc"
    echo "Alias '$alias_name' removed."
}

# Prompt the user for the path to the alias file
read -p "Enter the path to the file containing aliases: " alias_file

# Expand '~' to the home directory
alias_file=$(eval echo "$alias_file")

# Check if the alias file exists
if [ ! -f "$alias_file" ]; then
    echo "Error: Alias file '$alias_file' not found."
    exit 1
fi

# Output file
output_file=".aliascheck_output.txt"

echo "Checking for matching aliases..."

# Loop through each line in the file
while IFS= read -r line; do
    # Check if the line starts with "alias"
    if [[ $line == alias* ]]; then
        # Extract the alias name
        alias_name=$(echo "$line" | cut -d ' ' -f 2)
        if grep -q "alias $alias_name=" "$HOME/.bashrc"; then
            echo "Matching alias found: $alias_name"
            read -p "Do you want to remove this alias? (y/n): " choice
            case "$choice" in
                y|Y ) remove_aliases "$alias_name" >> "$output_file";;
                n|N ) echo "Alias '$alias_name' not removed." >> "$output_file";;
                * ) echo "Invalid choice. Alias '$alias_name' not removed." >> "$output_file";;
            esac
        else
            echo "No matching alias found for: $alias_name" >> "$output_file"
        fi
    fi
done < "$alias_file"

echo "Alias check complete. Output saved to '$output_file'."

