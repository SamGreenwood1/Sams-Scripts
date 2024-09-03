#!/bin/bash

# Function to get user input
get_search_term() {
    read -p "Enter the search term: " search_term
}

# Function to search packages in Snap
search_snap() {
    if command -v snap &> /dev/null; then
        echo "Searching in Snap for '$search_term'..."
        snap find "$search_term"
    else
        echo "Snap is not installed. Skipping Snap search."
    fi
}

# Function to search packages in distribution repositories and AUR
search_distribution_and_aur() {
    echo "Searching in distribution repositories for '$search_term'..."

    # List of common package managers
    local package_managers=("apt" "dnf" "yum" "zypper" "zypp" "pacman")

    local found_manager=""
    for manager in "${package_managers[@]}"; do
        if command -v "$manager" &> /dev/null; then
            found_manager="$manager"
            break
        fi
    done

    if [ -n "$found_manager" ]; then
        "$found_manager" search "$search_term"
    else
        echo "No supported package manager found. Cannot search in distribution repositories."
    fi

    # Check if yay (AUR helper) is installed and search AUR
    if command -v yay &> /dev/null; then
        echo "Searching in AUR for '$search_term'..."
        yay -Ss "$search_term"
    else
        echo "AUR support is not available. Install 'yay' to search in the AUR."
    fi
}

# Main function
main() {
    get_search_term
    search_snap
    search_distribution_and_aur
}

# Run the main function
main
