# Name: repo-table.sh
# Author: Sam Greenwood
# Date: 2020-05-01
# Description: Script to generate a table of site information from .info.txt files

# Change to active user's root directory
cd ~

# Find all site directories and store their relative paths in an array
sites=($(find . -maxdepth 1 -type d -name "*.*" -not -path '*/\.*' -printf '%P\n'))

# Create table header
table="| Site Name | Repo Name | Repo Org | Theme Name | Theme Dev | Site Dir |\n|---|---|---|---|---|---|\n"

# Loop through site directories
for site in "${sites[@]}"
do
  # Parse info from .info.txt file
  site_name=$(grep "Site Name:" $site/.info.txt | awk '{$1=$2=""; print $0}' | sed 's/^[[:space:]]*//')
  repo_name=$(grep "Repo Name:" $site/.info.txt | awk '{print $3}')
  repo_org=$(grep "Repo Org:" $site/.info.txt | awk '{print $3}')
  theme_name=$(grep "Theme Name:" $site/.info.txt | awk '{print $3}')
  theme_dev=$(grep "Theme Dev:" $site/.info.txt | awk '{print $3}')

  # Add table row
  table="$table| $site_name | $repo_name | $repo_org | $theme_name | $theme_dev | $site |\n"
done

# Print table to terminal
echo -e $table

# Save table to file
echo -e $table > ~/scripts/script-files/site_info_table.txt
