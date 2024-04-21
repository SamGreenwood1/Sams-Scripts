#!/bin/bash

# Define the backup directory
backup_dir="$HOME/backups"

# Define the backup filename with the current date
backup_filename="backups_$(date +%Y-%m-%d).tar.gz"

# Create the backup directory archive with the current date in the filename
tar -czvf "$backup_filename" "$backup_dir"

# Remove the existing backup directory
rm -rf "$backup_dir"

# Recreate the backup directory
mkdir "$backup_dir"

# Backup the directories and files
tar -czvf "$backup_dir/html.tar.gz" "/var/www/html"
tar -czvf "$backup_dir/cgpbv2.tar.gz" "~/cgpbv2"
tar -czvf "$backup_dir/themes.tar.gz" "~/themes"
tar -czvf "$backup_dir/cv.tar.gz" "~/cv.samgreenwood.ca"
tar -czvf "$backup_dir/scripts.tar.gz" "~/scripts"
tar -czvf "$backup_dir/tns.tar.gz" "~/tns-link-dump"
tar -czvf "$backup_dir/bank.tar.gz" "~/bank.cgapps.site"
tar -czvf "$backup_dir/docs.tar.gz" "~/docs.samgreenwood.tech"
tar -czvf "$backup_dir/setup.tar.gz" "~/setup-from-backup.sh"
tar -czvf "$backup_dir/proposals.tar.gz" "~/camp-proposals.samgreenwood.ca"
tar -czvf "$backup_dir/samgoesbts.tar.gz" "~/samgoesbts.com"
tar -czvf "$backup_dir/apache.tar.gz" "/etc/apache2/sites-available"
tar -czvf "$backup_dir/new.tar.gz" "~/new.samgreenwood.ca"
tar -czvf "$backup_dir/tech.tar.gz" "~/samgreenwood.tech"

# Backup the backup directory
tar -czvf "~/backup.tar.gz" "$backup_dir"

# Print a success message
echo "Backup completed successfully"
