# Name: create_hugo_sites.sh
# Author: Sam Greenwood
# Date: 2023-04-04
# Description: Script to create Hugo sites for all sites in site_info_table.txt

#!/bin/bash

# Read the site information from site_info_table.txt, skipping the header row
read header < !/scritps/script-files/site_info_table.txt
while read -r line; do
  # Split the line into columns based on the delimiter (assuming it's a tab)
  IFS=$'\t' read -ra columns <<< "$line"
  
  # Extract the relevant columns and store them in variables
  site_name="${columns[0]}"
  repo_name="${columns[1]}"
  repo_org="${columns[2]}"
  theme_name="${columns[3]}"
  theme_dev="${columns[4]}"
  site_dir="${columns[5]}"
  
  # Create the Hugo site in the site directory
  # hugo new site $site_dir
  cd $site_dir
  
  # Add the theme as a submodule
  git init
  git submodule add https://github.com/$theme_dev/$theme_name.git themes/$theme_name
  
  # Create a new Git repository and commit the changes
  git add .
  git commit -m "Initial commit"
  
  # Create a private GitHub repository and push the changes
  gh repo create $repo_org/$repo_name --private
  git push --set-upstream origin main
  
  # Return to the home directory
  cd ~/
done < <(tail -n +2 ~/scripts/script-files/site_info_table.txt)
