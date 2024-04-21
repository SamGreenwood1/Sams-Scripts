# Name: create_github_repos.sh
# Author: Sam Greenwood
# Date: 2021-09-15
# Description: Script to create github repos for all sites in ~/sites.txt

# Find all site directories in home directory and exclude hidden directories
sites=($(find ~ -maxdepth 1 -type d -name "*.*" -not -path '*/\.*' -printf '%f\n'))

# Read site info from site_info_table.txt into associative array
declare -A site_info
while IFS='=' read -r key value
do
    site_info["$key"]="$value"
done < site_info_table.txt

# Loop through each site directory
for site in "${sites[@]}"
do
    # Get repo_name and repo_org from site_info array
    repo_name=${site_info["$site.repo_name"]}
    repo_org=${site_info["$site.repo_org"]}

    # Navigate to site directory
    cd $site

    # Create repo using gh cli
    gh repo create $repo_org/$repo_name --private

    # Push changes to repo
    git remote add origin git@git.samgreenwood.ca:29419:$repo_org/$repo_name.git
    git push -u origin main

    # Navigate back to parent directory
    cd ..
done
