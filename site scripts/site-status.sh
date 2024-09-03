#!/bin/bash

# Get virtual host information using apache2ctl
virtual_hosts=$(apache2ctl -S)

# Get module status using a2query
modules=$(a2query -s)

# Combine data into a single table
paste -d '\n' <(echo "$virtual_hosts") <(echo "$modules") | while read -r virtual_host && read -r module; do
    url=$(echo "$virtual_host" | awk '{print $2}')
    printf "%-30s %-30s %-20s %-50s\n" "$virtual_host" "$url" "$module"
done | column -t
