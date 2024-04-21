#!/bin/bash

# Define the path to the site_info_table.txt file
SITE_INFO_FILE="/root/scripts/script-files/site_info_table.txt"

# Check if the file exists
if [ ! -f "$SITE_INFO_FILE" ]; then
  echo "Error: $SITE_INFO_FILE file not found."
  exit 1
fi

# Loop through each line in the file
while IFS= read -r line || [[ -n "$line" ]]; do
  # Split the line into an array
  IFS='|' read -ra fields <<< "$line"
  
  # Extract the values from the array
  username=${fields[0]}
  sitename=${fields[1]}
  domain=${fields[2]}
  
  # Generate the configuration file name
  conf_file="/etc/apache2/sites-available/$username-$sitename.conf"
  
  # Create the configuration file
  echo "Creating config file for $username | $domain |..."
  sudo echo "<VirtualHost *:80>
    ServerName $domain
    ServerAlias www.$domain
    DocumentRoot /var/www/$username/$sitename
    ErrorLog /var/log/apache2/$username-$sitename-error.log
    CustomLog /var/log/apache2/$username-$sitename-access.log combined
</VirtualHost>" > "$conf_file"
  
  # Enable the site
  echo "Enabling site $username | $domain |..."
  sudo a2ensite "$username-$sitename"
  
done < "$SITE_INFO_FILE"

# Reload Apache
echo "Reloading Apache..."
sudo systemctl reload apache2
