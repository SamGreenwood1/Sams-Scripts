#!/bin/bash

# Get a list of site directories
dirs=$(find ~ -maxdepth 1 -type d -name "*.*" -not -path '*/\.*')

# Loop through the directories
for dir in $dirs; do
  # Change into the directory
  cd "$dir"

  # Check if the directory is a Git repository
  if [ -d .git ]; then
    # Reset the repository
    git reset --hard
#    git clean -fd
  fi

  # Change back to the parent directory
  cd ..
done
