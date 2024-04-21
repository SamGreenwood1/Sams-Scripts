#!/bin/bash

# Function to search for a package in the distribution's package repository
search_repo() {
  local package_name="$1"
  
  # Check if the package is available in the distribution's repository
  if command -v apt &> /dev/null; then
    apt search "$package_name"
  elif command -v dnf &> /dev/null; then
    dnf search "$package_name"
  elif command -v pacman &> /dev/null; then
    pacman -Ss "$package_name"
  else
    echo "Unsupported package manager. Please update the script with your package manager's search command."
    exit 1
  fi
}

# Function to search for a Snap package
search_snap() {
  local package_name="$1"
  
  # Check if Snap is installed
  if [ -x "$(command -v snap)" ]; then
    # Search for the package in the Snap store
    snap find "$package_name"
  else
    echo "Snap is not installed. Please install Snap and try again."
    exit 1
  fi
}

# Main script
if [ $# -eq 0 ]; then
  echo "Usage: $0 <package_name>"
  exit 1
fi

package_name="$1"

echo "Searching for '$package_name' in the distribution's package repository:"
search_repo "$package_name"

echo
echo "Searching for '$package_name' in the Snap store:"
search_snap "$package_name"
