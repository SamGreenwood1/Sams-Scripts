#!/bin/bash

# Old site names to be replaced
old_sites=("bank.cgapps.site" "samgreenwood.tech" "samgoesbts.com" "camp-proposals.samgreenwood.ca"
           "cv.samgreenwood.ca" "links" "tns-link-dump" "cgpbv2" "dash" "samgreenwood.ca"
           "docs.samgreenwood.tech")

# New site names
new_sites=("cg-program-bank" "SG-Tech" "SamGoesBTS" "camp-proposals" "cv" "links" "tns-link-dump"
           "cgpbv2" "dash" "SG-Tech-Docs" "new-personal-site")

# List of Apache2 config files (without path)
config_files=("cg-program-bank.conf" "greenwoodtech-site.conf" "samgoesbts-site.conf"
              "camp-proposals.conf" "cv.conf" "links.conf" "tns-link-dump.conf"
              "dash.conf" "main-site.conf"
              "cgpbv2.conf" "greenwoodtech-docs.conf" "personal-site-temp.conf")

# Function to replace strings in a file
function replace_string_in_file() {
  local old_site="$1"
  local new_site="$2"
  local file="$3"
  
  # Check if old site, new site, and config file name are similar, then skip replacement
  if [[ "$old_site" == "$new_site" && "$old_site" == "${file%.*}" ]]; then
    echo "Skipping replacement for '$old_site' in '$file' (config file name matches new site name)."
  else
    # Perform the replacement using sed (stream editor)
    # Exclude ServerName field from replacements
    sudo sed -i "/ServerName/! s/${old_site}/${new_site}/g" "$sites_available_dir/$file"
    echo "Replaced '$old_site' with '$new_site' in '$sites_available_dir/$file'"
  fi
}

# Function to update linked public_html directories
function update_public_html_dir() {
  local old_site="$1"
  local new_site="$2"
  local linked_dir="/var/www/html/${old_site}"
  
  # Check if the linked directory exists
  if [ -L "$linked_dir" ]; then
    # Rename the linked directory to the new site name
    sudo mv "$linked_dir" "/var/www/html/${new_site}"
    echo "Updated linked 'public_html' directory for '$old_site' to '$new_site'."
  else
    echo "Linked 'public_html' directory for '$old_site' not found, skipping update."
  fi
}

# Loop through the arrays and perform replacements for each file
for ((i = 0; i < ${#old_sites[@]}; i++)); do
  old_site="${old_sites[i]}"
  new_site="${new_sites[i]}"
  file="${config_files[i]}"
  
  # Perform replacements in the Apache config file
  replace_string_in_file "$old_site" "$new_site" "$file"
  
  # Update the linked public_html directory
  update_public_html_dir "$old_site" "$new_site"
done

# Reload Apache to apply changes
sudo service apache2 reload

echo "All replacements and linked directory updates completed."
