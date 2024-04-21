#!/bin/bash
find ../../ \( -type f \( -name '*.toml' -o -name '*.yaml' \) \) -not \( -path */.* -o -path *example* -o -path *themes* -o -path *save* -o -path *bak* \) -exec dirname {} \; | sort -u | while read -r dir; do     
echo Contents of directory: ;
ls -1;
echo -----------------------; done
