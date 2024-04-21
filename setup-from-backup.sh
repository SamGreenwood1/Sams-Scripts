# Name: setup-from-backup.sh
# Author: Sam Greenwood
# Date: 2023-04-10
# Description: This script is used to setup a new server with apache2, hugo, and certbot

# install apache2 (all) and snapd
sudo apt install apache2 apache2-utils apache2-doc snapd

# update snapd
sudo snap install core; sudo snap refresh core 
sudo ln -s /snap/bin/certbot /usr/bin/certbot # create symlink for certbot

# install hugo and certbot via snap
sudo snap install hugo
sudo snap install certbot --classic

# Untar backup files stored as .tar.gz stored in ~
tar -xvzf ~/backup.tar.gz

# unarchive .tar.gz files in ~/backups and move directories into home directory (bts.tar.gz, certs.tar.gz, cgpbv2.tar.gz, new-site.tar.gz, sites.tar.gz, tech-site.tar.gz, camp-proposals.tar.gz, cgpb.tar.gz, cv.tar.gz, scripts.tar.gz, tech-docs.tar.gz)
tar -xvzf ~/backups/bts.tar.gz
tar -xvzf ~/backups/certs.tar.gz
tar -xvzf ~/backups/cgpbv2.tar.gz
tar -xvzf ~/backups/new-site.tar.gz
tar -xvzf ~/backups/sites.tar.gz
tar -xvzf ~/backups/tech-site.tar.gz
tar -xvzf ~/backups/camp-proposals.tar.gz
tar -xvzf ~/backups/cv.tar.gz
tar -xvzf ~/backups/scripts.tar.gz
tar -xvzf ~/backups/tech-docs.tar.gz

# anarchive backup files
tar -cvzf ~/*.tar.gz

# move apache config files from ~/certs to /etc/apache2/sites-available
sudo mv ~/certs/* /etc/apache2/sites-available

# move apache site files from ~/sites to /var/www


# reinitialize all hugo sites (stored in ~) - cgpbv2,new.samgreenwood.ca,bank.cgapps.site, cv.samgreenwood.ca, camp-proposals-feedback.samgreenwood.ca, samgoesbts.com, camp-proposals.samgreenwood.ca, docs.samgreenwood.tech, samgreenwood.tech
cd ~/cgpbv2
hugo
cd ~/new.samgreenwood.ca
hugo
cd ~/bank.cgapps.site
hugo
cd ~/cv.samgreenwood.ca
hugo
cd ~/camp-proposals.samgreenwood.ca
hugo
cd ~/samgoesbts.com
hugo
cd ~/docs.samgreenwood.tech
hugo
cd ~/samgreenwood.tech
hugo


# configure apache2 only http
cd /etc/apache2/sites-available
sudo a2ensite samgreenwood.tech.conf
sudo a2ensite bank.cgapps.site.conf
sudo a2ensite camp-proposals.samgreenwood.ca.conf
sudo a2ensite cv.samgreenwood.ca.conf
sudo a2ensite docs.samgreenwood.tech.conf
sudo a2ensite samgoesbts.com.conf
sudo a2ensite new.samgreenwood.ca.conf
sudo a2ensite cgpbv2.conf
sudo systemctl restart apache2

# reinitalize git repos that existed on an old server in dir where .git and .gitignore files already exist and repo already exists on github
# cd ~/sites/cgpbv2
# git init
# git add .
# git commit -m "reinitialize git repo"
# git remote add origin git@it@github.com:samgreenwood/cgpbv2.git
# git push -u origin master
# cd ~/sites/new.samgreenwood.ca