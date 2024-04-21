
#!/bin/bash

# name: site-setup.sh
# author: Sam Greenwood
# date: 2020-05-01
# description: script to setup hugo sites on ubuntu server

# set default values for variables
site_name=""
repo_name=""
repo_org=""
theme_name=""
theme_dev=""
site_dir=""

# function to setup site
setup_site() {
    # create website directory
    sudo mkdir -p /var/www/html/$site_name/public_html

    # link to hugo site
    sudo ln -s $site_dir/public /var/www/html/$site_name/public_html

    # create apache2 config file
    sudo echo "<VirtualHost *:80>
        ServerName $site_name
        ServerAlias www.$site_name
        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/html/$site_name/public
        ErrorLog /var/www/html/$site_name/error.log
        CustomLog /var/www/html/$site_name/access.log combined
    </VirtualHost>" > /etc/apache2/sites-available/$site_name.conf

    # enable apache2 site
    sudo a2ensite $site_name.conf

    # reload apache2
    sudo systemctl reload apache2

    # initialize certbot
    sudo certbot --apache -d $site_name -d www.$site_name --email $admin_email --agree-tos

    # reload apache2
    sudo systemctl reload apache2

    # generate site info file
    generate_site_info
}
# function to generate site info file
get_site_info() {
    local site_name=$1
    local site_info_file=~/scripts/script-files/site_info_table.txt
    local site_info=$(awk -v site_name="$site_name" 'BEGIN {FS="|";OFS="=";ORS=" "} NR>2 {print $2,$3,$4,$5,$6,$7}' "$site_info_file" | grep "$site_name")
    echo "$site_info"
}

# function to display help
show_help() {
    cat ~/scripts/.setup_help.sh
}

# parse arguments
while [[ $# -gt 0 ]]
do
    key="$1"

    case $key in
        -n|--site-name)
        site_name="$2"
        shift
        shift
        ;;
        -r|--repo-name)
        repo_name="$2"
        shift
        shift
        ;;
        -o|--repo-org)
        repo_org="$2"
        shift
        shift
        ;;
        -t|--theme-name)
        theme_name="$2"
        shift
        shift
        ;;
        -d|--theme-dev)
        theme_dev="$2"
        shift
        shift
        ;;
        -s|--site-dir)
        site_dir="$2"
        shift
        shift
        ;;
        -h|--help)
        show_help
        exit 0
        ;;
        *)
        echo "Unknown option: $key"
        echo "Use -h or --help for help."
        exit 1
        ;;
    esac
done

# display menu and get user selection
echo "Please select an option:"
echo "1. Setup site"
echo "2. Generate site info file"
echo "3. Display help"
read selection

# execute selected option
case $selection in
    1)
        setup_site
        ;;
    2)
        generate_site_info
        batcat $site_dir/.info.txt
        ;;
    3)
        show_help
        ;;
    *)
        echo "Invalid selection: $selection"
        ;;
esac

exit 0
