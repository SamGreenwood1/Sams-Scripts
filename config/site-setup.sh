# name: site-setup.sh
# author: Sam Greenwood
# date: 2020-05-01
# description: script to setup hugo sites on ubuntu server

# use table from repo-table.sh to all required info
table=$(cat ~/scripts/script-files/site_info_table.txt)

# loop through each site in table to setup apache2 and certbot
while IFS='|' read -r site_name repo_name repo_org theme_name theme_dev site_dir
do
    # skip table header
    if [[ $site_name != " Site Name " ]]; then
        # remove leading and trailing whitespace
        site_name=$(echo $site_name | sed 's/^[[:space:]]*//')      # remove leading and trailing whitespace
        repo_name=$(echo $repo_name | sed 's/^[[:space:]]*//')      # remove leading and trailing whitespace
        repo_org=$(echo $repo_org | sed 's/^[[:space:]]*//')        # remove leading and trailing whitespace
        theme_name=$(echo $theme_name | sed 's/^[[:space:]]*//')    # remove leading and trailing whitespace
        theme_dev=$(echo $theme_dev | sed 's/^[[:space:]]*//')      # remove leading and trailing whitespace
        site_dir=$(echo $site_dir | sed 's/^[[:space:]]*//')        # remove leading and trailing whitespace

        # create website directory
        sudo mkdir -p /var/www/$repo_name/public_html        # create website directory
        ## link to hugo site
        sudo ln -s $site_dir/public /var/www/$repo_name/public_html      # link to hugo site
        # create apache2 config file
        sudo echo "<VirtualHost *:80>
    ServerName $site_name
    ServerAlias www.$site_name
    ServerAdmin webmaster@localhost
    DocumentRoot /var/www/$site_name/public
    ErrorLog /var/www/$site_name/error.log
    CustomLog /var/www/$site_name/access.log combined
</VirtualHost>" > /etc/apache2/sites-available/$repo_name.conf      # create apache2 config file

        # enable apache2 site
        sudo a2ensite $site_name.conf

        # reload apache2
        sudo systemctl reload apache2

        # initialize certbot
        sudo certbot --apache -d $repo_name -d www.$repo_name --email sam@samgreenwood.ca

        # reload apache2
        sudo systemctl reload apache2
    fi
done <<< "$table"