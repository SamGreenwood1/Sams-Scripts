# author: Sam Greenwood
# date: 2021-07-19
# description: server configuration script
# Path: server-conf-1.sh

# create site directories

# create site cv.samgreenwood.ca

# hugo new site cv.samgreenwood.ca        # create new site
cd cv.samgreenwood.ca       # go to site directory
gh repo create cv --private
# cp ~/backups/cv/* .
echo "# cv" >> README.md        # create readme
git init        # initialize local git repo
git submodule add https://github.com/gurusabarish/hugo-profile theme/hugo-profile       # add theme
git add .       # add all files
git commit -m "Initial commit"      # commit to local repo
git branch -M main
git remote add origin git@github.com:SamGreenwood1/cv.git       # add remote
git push -u origin master       # push to github

# create site new.samgreenwood.ca

# hugo new site new.samgreenwood.ca       # create new site
cd ~/new.samgreenwood.ca      # go to site directory
# cp ~/backups/personal-site/* .
gh repo create personal-site --private
echo "# Personal Site" >> README.md        # create readme
git submodule add https://github.com/negrel/hugo-theme-pico.git themes/pico     # add theme
./setup.sh      # run setup script
npm install     # install node modules
git add .       # add all files
git commit -m "Initial commit"     # commit to local repo
git branch -M main       # change branch name to main
git remote add origin git@github.com:SamGreenwood1/personal-site.git        # add remote
git push -u origin master       # push to github
# cd ..       # back to home directory

# create site camp-proposals.samgreenwood.ca

# hugo new site camp-proposals.samgreenwood.ca        # create new site
cd ~/camp-proposals.samgreenwood.ca       # go to site directory
gh repo create camp-proposals --private
echo "# camp-proposals" >> README.md        # create readme
git init        # initialize local git repo
git submodule add https://github.com/thingsym/hugo-theme-techdoc.git themes/hugo-theme-techdoc
git add .
git commit -m "Initial commit"      # commit to local repo
git remote add origin git@github.com:SamGreenwood1/camp-proposals.git   # add remote
git push -u origin master                                               # push to github

# create site camp-proposals-feedback.samgreenwood.ca

hugo new site camp-proposals-feedback.samgreenwood.ca                   # create new site
cd ~/camp-proposals-feedback.samgreenwood.ca
gh repo create camp-proposals-feedback --private
npm install && npm run gulp watch                                       # install node modules and start gulp watch
echo "# camp-proposals-feedback" >> README.md                                    # create readme
git init        # initialize local git repo
git submodule add https://github.com/thingsym/hugo-theme-techdoc.git themes/hugo-theme-techdoc      # add theme
git add .       # add all files
git commit -m "Initial commit"      # commit to local repo
git remote add origin git@github.com:SamGreenwood1/camp-proposals-feedback.git      # add remote
git push -u origin master       # push to github

# create site samgreenwood.tech

# hugo new site samgreenwood.tech     # create new site
cd ~/samgreenwood.tech        # go to site directory
echo "# Sam Greenwood Tech" >> README.md        # create readme
git init        # initialize local git repo
gh repo create greenwood-tech-services/samgreenwoodtech-website --private
git submodule add -b main https ://github.com/nunocoracao/blowfish.git themes/blowfish      # add theme
git add .       # add all files
git commit -m "Initial commit"      # commit to local repo
git remote add origin git@github.com:greenwood-tech-services/samgreenwoodtech-website.git       # add remote
git push -u origin master       # push to github
# cd ..       # back to home directory
# hugo new site docs.samgreenwood.tech     # create new site
cd ~/docs.samgreenwood.tech        # go to site directory
gh repo create greenwood-tech-services/samgreenwoodtech-docs --private
echo "# Sam Greenwood Tech Docs" >> README.md    # create readme
git init    # initialize local git repo
git submodule add https://github.com/thingsym/hugo-theme-techdoc.git themes/hugo-theme-techdoc  # add theme
git add .   # add all files
git commit -m "Initial commit"  # commit to local repo
git remote add origin git@github.com:greenwood-tech-services/samgreenwoodtech-docs.git  # add remote
git push -u origin master   # push to github
npm install     # install node modules
npm run gulp watch      # start gulp watch

# create site samgoesbts.com

# hugo new site samgoesbts.com  # create new site
cd ~/samgoesbts.com   # go to site directory
gh repo create samgoesbts-website --private
#cp ~/backups/bts/* .
echo "# Sam Goes BTS Website" >> README.md # create readme
git init  # initialize local git repo
git submodule add https://github.com/CloudWithChris/hugo-creator.git themes/hugo-creator # add theme
git add .   # add all files
git commit -m "Initial commit"  # commit to local repo
git remote add origin SamGreenwood1/samgoesbts-website.git  # add remote
git push -u origin master   # push to github

# create site bank.cgapps.site

# hugo new site bank.cgapps.site  # create new site
cd ~/bank.cgapps.site   # back to home directory
echo "# CG Program Bank v1" >> README.md # create readme
gh repo create CG-Program-Bank --private
git submodule add https://github.com/unicef/inventory-hugo-theme.git themes/inventory
git add .   # add all files
git commit -m "Initial commit"  # commit to local repo
git remote add origin SamGreenwood1/CG-Program-Bank.git  # add remote
git push -u origin master   # push to github

# cerate github repo with gh cli via for loop (must be in home directory)


# build sites with for loop
for i in $(ls -d */); do cd $i; hugo; cd ..; done