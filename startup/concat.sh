#!/bin/bash

# Name: concat      # Author: Sam Greenwood     Description: Concatenates files matching search terms into a single file
# Arguments: -f filename -s search_term [-s search_term...]
# Returns: 0 on success, 1 on failure   Example: concat -f output.txt -s *.txt
# Date: 2024-05-17  Updated: 2024-05-17     Version: a0.1
 

concat() {
    local OPTIND opt filename search_terms
    case $1 in
        help)
            \cat ~/.startup/help/concat
            return
            ;;
        *)
            usage() {
                echo "Usage: concat -f filename -s search_term [-s search_term...]"
                return 1
            }

            while getopts ":f:s:" opt; do
                case ${opt} in
                    f)
                        filename=$OPTARG
                        ;;
                    s)
                        search_terms+=("$OPTARG")
                        ;;
                    \?)
                        usage
                        return 1
                        ;;
                esac
            done
            shift $((OPTIND -1))

            if [ -z "${filename}" ] || [ -z "${search_terms[*]}" ]; then
                usage
                return 1
            fi

            for search_term in "${search_terms[@]}"; do
                echo "Searching for files matching: $search_term"

                files=$(ls -1 | grep "$search_term")

                if [ -z "$files" ]; then
                    echo "No files found matching the search term."
                    continue
                fi

                while IFS= read -r file; do
                    if [ ! -f "$file" ]; then
                        echo "Error: $file is not a regular file."
                        continue
                    fi

                    echo "Processing file: $file"
                    cat "$file" >> "$filename"
                    echo "" >> "$filename"

                    if [ $? -ne 0 ]; then
                        echo "Error: Failed to concatenate $file to $filename"
                    fi
                done <<< "$files"
            done

            echo "File concatenation complete."
            ;;
    esac
}