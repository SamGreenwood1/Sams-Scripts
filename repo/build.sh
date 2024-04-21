# author: Sam Greenwood
# date: 2021-07-19
# description: server configuration script
# Path: server-conf.sh

#!/bin/bash

# Get list of site directories
sites=$(find ~ -maxdepth 1 -type d -name "*.*" -not -path '*/\.*' -printf '%f\n')

# Loop through each site directory
for site in $sites; do
  # Parse repo name and org from info.txt
  info_file="$site/info.txt"
  repo_name=$(grep -Po 'repo_name=\K.*' "$info_file")
  org=$(grep -Po 'org=\K.*' "$info_file")

  # Navigate to site directory
  cd "$site"

  # Initialize Git repository if not already initialized
  if ! [ -d .git ]; then
    git init
    git add .
    git commit -m "Initial commit"
  fi

  # Add remote origin
  remote_url="git@github.com:$org/$repo_name.git"
  git remote add origin "$remote_url"

  # Push to GitHub using GH CLI
  gh repo view "$org/$repo_name" > /dev/null 2>&1
  if [ "$?" -ne 0 ]; then
    gh repo create "$org/$repo_name" --private
  fi
  git push -u origin main
done