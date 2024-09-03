#!/bin/bash

# Function to search for a package in Snap
search_snap() {
    local package_name="$1"
    local snap_find_result
    snap_find_result=$(snap find "$package_name" 2>/dev/null)
    if [[ -n $snap_find_result ]]; then
        echo "Package found in Snap:"
        echo "$snap_find_result"
    else
        echo "Package not found in Snap."
    fi
}

# Function to search for a package in distribution repositories
search_distribution() {
    local package_name="$1"
    local package_manager

    case $(lsb_release -is) in
        "Ubuntu" | "LinuxMint" | "Debian") package_manager="apt" ;;
        "Fedora" | "RedHat" | "CentOS") package_manager="dnf" ;;
        "openSUSE" | "SUSE") package_manager="zypper" ;;
        "Arch" | "Manjaro") package_manager="pacman" ;;
        *)
            echo "Unsupported distribution."
            return
            ;;
    esac

    echo "Searching in $(lsb_release -is) repositories using $package_manager..."
    
    # Search for the package using the appropriate package manager
    sudo "$package_manager" search "$package_name"
}

# Function for user interactions and main script logic
main() {
    read -p "Enter the package name: " package_name

    if command -v snap >/dev/null 2>&1; then
        echo "Snap is installed."
        search_snap "$package_name"
    else
        echo "Snap is not installed."
    fi

    search_distribution "$package_name"
}

# Call the main function to start the script
main
