# Reset Git to remove stored credentials
git config --global --unset-all credential.helper

# Remove existing repositories
while read -r repo; do
  # Skip empty lines
  if [[ -z "$repo" ]]; then
    continue
  fi
  
  # Split the repository into organization and name
  IFS='/' read -r repo_org repo_name <<< "$repo"
  
  # Remove the repository
  gh repo delete "${repo_org}/${repo_name}" --yes
done < ~/scripts/script-files/repos.txt
