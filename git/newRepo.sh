#!/bin/bash
# Version b0.0.11.1

reset_repository() {
    read -p "Do you want to reset the repository? (y/n): " resetRepo

    if [ "$resetRepo" = "y" ]; then
        rm -rf .git
        echo "Repository reset."
    fi
}

add_submodule() {
    read -p "Enter submodule URL (GitHub repository URL): " submoduleUrl
    read -p "Enter subdirectory for the submodule (press Enter for default): " submoduleDir
    submoduleDir=${submoduleDir:-.}

    # Check if the submodule URL is from GitHub
    if [[ "$submoduleUrl" == *github.com* ]]; then
        git submodule add $submoduleUrl themes/"$submoduleDir"
    fi
}

initialize_repository() {
    git init
    git add .
    git commit -m "Initial commit"
}

push_changes() {
    if git remote | grep -q "origin"; then
        echo "Remote 'origin' already exists. Pushing changes to the existing remote."
        git push -u origin master
    else
        git remote add origin $gitUrl
        git push -u origin master
        echo "Remote 'origin' added and changes pushed."
    fi
}

set_default_branch() {
    if [ -z "$(git symbolic-ref --short -q HEAD)" ]; then
        read -p "Enter the name of the default branch (e.g., main): " defaultBranch
        git branch -M $defaultBranch
        echo "Default branch set to '$defaultBranch'."
    fi
}

# Check if orgName and repoName are provided as arguments
if [ $# -ne 2 ]; then
    echo "Usage: $0 <orgName> <repoName>"
    exit 1
fi

orgName=$1
repoName=$2
gitUrl="https://git.samgreenwood.ca/$orgName/$repoName.git"

reset_repository

# Prompt user if submodules should be added
read -p "Do you want to add submodules? (y/n): " addSubmodules

# Create a new Git repository
echo "Creating new Git repository: $gitUrl"
initialize_repository

# Add submodules if the user chooses to
if [ "$addSubmodules" = "y" ]; then
    add_submodule
fi

push_changes
set_default_branch

# Display information about the new repository
echo -e "\nNew repository created successfully:"
echo "Organization: $orgName"
echo "Repository: $repoName"
echo "Git URL: $gitUrl"
echo -e "\nYou can now continue working on your project and push changes to the remote repository."

exit 0
