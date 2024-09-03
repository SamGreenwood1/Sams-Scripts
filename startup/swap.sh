#!/bin/bash

# Name: swap    # Author: Sam Greenwood     # Description: Swaps two files
# Arguments: 2 files to swap
#   $1: The first file, $2: The second file
# Return: 0 on success, 1 on failure    # Example: swap file1 file2
# Date: 2024-05-17  # Updated: 2024-05-17   # Version: a0.1

function swap() {
    if [ -z "$1" ] || [ -z "$2" ] || [ ! -z "$3" ]; then
        echo "Expected 2 file arguments, abort!"
        return 1
    fi
    
    for file in "$1" "$2"; do
        if [ ! -f "$file" ]; then
            echo "File '$file' not found, abort!"
            return 1
        fi
    done
    
    tmp=$(mktemp --tmpdir="$(dirname "$1")") || { echo "Failed to create temp file, abort!"; return 1; }
    
    mv "$1" "$tmp" || { echo "Failed to move first file '$1', abort!"; rm "$tmp"; return 1; }
    mv "$2" "$1" || { echo "Failed to move second file '$2', abort!"; mv "$tmp" "$1" && echo "Failed to restore state for $1"; return 1; }
    mv "$tmp" "$2" || { echo "Failed to move file: (unable to restore) '$1' has been left at '$tmp', '$2' as '$1'!"; return 1; }
}