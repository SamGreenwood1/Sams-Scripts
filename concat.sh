#!/bin/bash

concatenate_files() {
    read -p "Enter filename: " filename
    read -p "Enter search term: " search_term

    echo "Searching for files matching: $search_term"

files=$(ls -1 | grep "$search_term")

    # Iterate over each file in the list
    for file in $files; do
        echo "Processing file: $file"
        # Concatenate the contents of the matching files into the specified filename
        cat "$file" >> "$filename"
        echo "" >> "$filename"
    done

    echo "File concatenation complete."
}

# Call the function
concatenate_files
