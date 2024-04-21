#!/bin/bash

# Function to get user input
get_search_term() {
    read -p "Enter the search term: " search_term
}

# Function to search packages in Snap
search_snap() {
    if command -v snap &> /dev/null; then
        echo "Searching in Snap for '$search_term'..."
        snap_results=$(snap find "$search_term")
    else
        echo "Snap is not installed. Skipping Snap search."
    fi
}

# Function to search packages in a given package manager
search_in_package_manager() {
    local manager=$1
    local search_term=$2

    if command -v "$manager" &> /dev/null; then
        echo "Searching in $manager for '$search_term'..."
        manager_results=$("$manager" search "$search_term")
    else
        echo "$manager is not installed. Skipping $manager search."
    fi
}

# Function to search packages in distribution repositories and AUR
search_distribution_and_aur() {
    echo "Searching in distribution repositories for '$search_term'..."

    local package_managers=("apt" "dnf" "yum" "zypper" "zypp" "pacman")
    local aur_manager="yay"

    local found_manager=""
    for manager in "${package_managers[@]}"; do
        if command -v "$manager" &> /dev/null; then
            found_manager="$manager"
            break
        fi
    done

    if [ -n "$found_manager" ]; then
        search_in_package_manager "$found_manager" "$search_term"
    else
        echo "No supported package manager found. Cannot search in distribution repositories."
        if [ -n "$aur_manager" ]; then
            search_in_package_manager "$aur_manager" "$search_term"
        fi
    fi
}

# Function to print results in a table
print_results() {
    echo "Results:"
    if [ -n "$snap_results" ]; then
        echo "Snap Results:"
        echo "$snap_results"
    fi
    if [ -n "$manager_results" ]; then
        echo "Package Manager Results:"
        echo "$manager_results"
    fi
}

# Main function
main() {
    get_search_term
    search_snap
    search_distribution_and_aur
    print_results
}

# Run the main function
main
