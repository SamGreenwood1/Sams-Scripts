#!/bin/bash

# use table from site_info_table.txt to get all required info
table=$(cat ~/scripts/script-files/site_info_table.txt)

# loop through each site in table to setup apache2 and certbot
while IFS='|' read -r site_name repo_name repo_org theme_name theme_dev site_dir
do
    # skip table header
    if [[ $site_name != " Site Name " ]]; then
        # remove leading and trailing whitespace
        site_name=$(echo $site_name | sed 's/^[[:space:]]*//')
        repo_name=$(echo $repo_name | sed 's/^[[:space:]]*//')
        repo_org=$(echo $repo_org | sed 's/^[[:space:]]*//')
        theme_name=$(echo $theme_name | sed 's/^[[:space:]]*//')
        theme_dev=$(echo $theme_dev | sed 's/^[[:space:]]*//')
        site_dir=$(echo $site_dir | sed 's/^[[:space:]]*//')

        # create website directory
        sudo mkdir -p /var/www/html/$site_dir/public_html
        ## link to hugo site
        sudo ln -s $site_dir/public /var/www/html/$site_dir/public_html
        # create apache2 config file
        sudo tee /etc/apache2/sites-available/$repo_name.conf > /dev/null <<EOF
<VirtualHost *:80>
    ServerName $repo_name
    ServerAlias www.$repo_name
    ServerAdmin webmaster@localhost
    DocumentRoot /var/www/html/$site_dir/public_html
    ErrorLog /var/www/html/$site_dir/error.log
    CustomLog /var/www/html/$site_dir/access.log combined
</VirtualHost>
EOF

        # enable apache2 site
        sudo a2ensite $repo_name.conf

        # reload apache2
        sudo systemctl reload apache2

        # confirm that config file exists before running certbot
        if [ -f /etc/apache2/sites-available/$repo_name.conf ]; then
            # run certbot and agree to terms of service
            sudo certbot --apache -d $site_dir -d www.$site_dir --email sam@samgreenwood.ca --agree-tos --non-interactive
        else
            echo "Error: Apache config file for $repo_name not found, skipping certbot setup"
        fi

        # reload apache2
        sudo systemctl reload apache2
    fi
done <<< "$table"
