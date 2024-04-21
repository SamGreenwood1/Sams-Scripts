# Name: Server Configuration Script
# Author: Sam Greenwood
# Date: 2020-05-01
# Description: Script to configure a new Ubuntu server

# Get a list of site directories
dirs=$(find ~ -maxdepth 1 -type d -name "*.*" -not -path '*/\.*')

# Loop through the directories
for dir in $dirs; do
  # Check if the directory contains a Hugo site
  if [ -f "$dir/.info.txt" ]; then
    # Read the repository name, organization, theme developer, and theme name from the .info.txt file
    site_name=$(grep "Site Name:" $dir/.info.txt | awk '{$1=$2=""; print $0}' | sed 's/^[[:space:]]*//')
    repo_name=$(grep "Repo Name:" $dir/.info.txt | awk '{print $3}')
    repo_org=$(grep "Repo Org:" $dir/.info.txt | awk '{print $3}')
    theme_name=$(grep "Theme Name:" $dir/.info.txt | awk '{print $3}')
    theme_dev=$(grep "Theme Dev:" $dir/.info.txt | awk '{print $3}')

    # Change into the directory
    cd "$dir"

    # Initialize a Git repository in the site directory if not already initialized
    if [ ! -d .git ]; then
      git init
      echo "# " $site_name > README.md
      git add .
      git commit -m "Initial commit"
    fi

    # Create a new GitHub repository using gh cli if it does not already exist
    if ! gh repo view "$repo_org/$repo_name" > /dev/null 2>&1; then
      gh repo create "$repo_org/$repo_name" --private --confirm
    else
      echo "Repository already exists: $repo_org/$repo_name"
      continue
    fi

    # Push the repository to GitHub using the SSH URL
    git remote add origin "git@github.com:$repo_org/$repo_name.git"
    git push -u origin master

    # Add the specified Hugo theme to the site using git submodule
    git submodule add "https://github.com/$theme_dev/$theme_name.git" "themes/$theme_name"

    # Change the theme setting in the site's config file to the specified theme name
    sed -i "s/^theme = .*/theme = \"$theme_name\"/" config.toml config.yml config.yaml

    # Push the changes to the repository on GitHub
    git add .
    git commit -m "Add theme $theme_name"
    git push -u origin master

    # Change back to the parent directory
    cd ..
  fi
done
