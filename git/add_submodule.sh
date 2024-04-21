#!/bin/bash

SUBMODULE_URL=https://github.com/holehan/hugo-components-matomo.git 
SUBMODULE_PATH=themes/example-submodule

for dir in new.samgreenwood.ca docs.samgreenwood.tech samgoesbts.com samgreenwood.tech; do
  cd $dir
#  git submodule add $SUBMODULE_URL $SUBMODULE_PATH
#  git commit -m "Added submodule $SUBMODULE_PATH"
#  git push
#  nano conf*
  hugo
 cd ..
done
