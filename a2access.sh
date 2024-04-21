#!/bin/bash
## Version: v0.0.8

APACHE_CONF_DIR="/etc/apache2/sites-available"
WEBSITES_DIR="/home/sam/sites"
TEXT_EDITOR="nano"

select_category() {
  clear
  echo "Apache Configuration Categories:"

  local count=1
  # Process the level 1 of the tree output to build the first-level menu
  tree "$WEBSITES_DIR" -L 1 -d -i -f --noreport | grep -E -v '^\.\.?$' | while IFS= read -r line; do
    # Extract category from the line
    category=$(echo "$line" | awk -F/ '{print $NF}')
    
    # Display the category in the menu
    echo "$count. $category"
    count=$((count + 1))
  done

  echo "0. General Settings"
  echo "99. Exit"
}

select_site() {
  local category=$1
  clear
  echo "Select a site in the '$category' category:"

  local count=1
  # Process the level 2 of the tree output to build the second-level menu
  tree "$WEBSITES_DIR/$category" -L 1 -d -i -f --noreport | grep -E -v '^\.\.?$' | while IFS= read -r line; do
    # Extract site from the line
    site=$(echo "$line" | awk -F/ '{print $NF}')
    
    # Display the site in the menu
    echo "$count. $site"
    count=$((count + 1))
  done
}

get_files() {
  local category=$1
  case $category in
    0) echo "apache2.conf ports.conf";;
    *) echo "$APACHE_CONF_DIR/$category"/*;;
  esac
}

display_files() {
  local category=$1
  local files=$(get_files "$category")

  clear
  echo "Files in the '$category' category:"
  local count=1
  for file in $files; do
    echo "$count. $(basename "$file")"
    count=$((count + 1))
  done

  read -p "Enter the number of the file to view (or 'back' to go back): " choice

  if [ "$choice" != "back" ]; then
    file=$(echo $files | awk '{print $'$choice'}')
    open_file "$file"
  fi
}

open_file() {
  local file=$1
  clear
  echo "Opening $file with $TEXT_EDITOR..."
  $TEXT_EDITOR "$file"
  read -p "Press Enter to continue..."
}

while true; do
  select_category

  read -p "Enter the number of the category you want to explore (or '99' to exit): " choice

  case $choice in
    0) display_files 0;;
    99) echo "Exiting script. Goodbye!"; exit;;
    *) 
      selected_category=$(tree "$WEBSITES_DIR" -L 1 -d -i -f --noreport | grep -E -v '^\.\.?$' | awk NR==$choice | awk -F/ '{print $NF}')
      select_site "$selected_category"
      read -p "Enter the number of the site you want to explore (or 'back' to go back): " site_choice
      selected_site=$(tree "$WEBSITES_DIR/$selected_category" -L 1 -d -i -f --noreport | grep -E -v '^\.\.?$' | awk NR==$site_choice | awk -F/ '{print $NF}')
      display_files "$selected_site"
      ;;
  esac
done
