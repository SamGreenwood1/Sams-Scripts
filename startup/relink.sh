#!/bin/bash

# Name: relink.sh    Author: Sam Greenwood      Description: A script to manage symbolic links
# Arguments: <existing_or_new_link_name> <target_file_or_directory>
# Example: relink.sh linkname targetfile    Date: 2024-05-17    Updated: 2024-05-17     Version: a0.1 r1

relink() {
    if [ $# -ne 2 ]; then
        echo "Usage: $0 <existing_or_new_link_name> <target_file_or_directory>"
        exit 1
    fi

    link="$1"
    target="$2"

    if [ ! -e "$target" ]; then
        echo "Error: Target file or directory '$target' does not exist."
        exit 1
    fi

    if [ -L "$link" ]; then
        current_target=$(readlink -f "$link")
        if [ "$current_target" = "$target" ]; then
            echo "Symbolic link '$link' already points to '$target'."
            exit 0
        else
            echo "Reassigning symbolic link '$link' from '$current_target' to '$target'."
        fi
    elif [ -e "$link" ]; then
        echo "Error: '$link' already exists and is not a symbolic link."
        exit 1
    else
        echo "Creating symbolic link '$link' pointing to '$target'."
    fi

    ln -sf "$target" "$link"
    if [ $? -eq 0 ]; then
        echo "Symbolic link '$link' reassigned to '$target'."
    else
        echo "Error: Failed to reassign symbolic link '$link' to '$target'."
        exit 1
    fi
}