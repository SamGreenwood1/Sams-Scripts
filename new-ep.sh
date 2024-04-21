## title: Generate Show Page
## description: This script will generate a show page for the podcast
## author: Sam Greenwood
## date: 2023-06-05
## version: beta 0.1
## usage: ./generate-show-page.sh
## bash_version: 5.0.17(1)-release
## license: MIT License

## Generate Show Notes
echo "---"
echo "Date: \"$(date --utc +%FT%TZ)\""

## Get the description from user input
echo "Description: \"$(read -p "Description: " desc; echo $desc)\""

## Prompt for the title
echo "Title: \"$(read -p "Title: " title; echo $title)\""

## prompt for episode number
echo "episode: \"$(read -p "Episode: " episode; echo $episode)\""

## prompt for image
echo "image: \"$(read -p "Image: " image; echo $image)\""

## prompt for explicit (select from yes/no in menu bash)
PS3='Explicit? ' # Sets the menu prompt
select explicit in yes no # Creates a menu from the choices in the select statement
do
  case $explicit in   # The case statement then selects the appropriate option.
    yes)
      echo "explicit: \"yes\""  # This is displayed if "yes" is selected.
      break
      ;;
    no)
      echo "explicit: \"no\""   # This is displayed if "no" is selected.
      break
      ;;
    *)
      echo "invalid option $REPLY"  # This is displayed if an invalid option is selected.
      ;;
  esac
done

## prompt for hosts
echo "hosts:"  # This is displayed if an invalid option is selected.
while true; do
    read -p "Host: " host # This is displayed if an invalid option is selected.
    if [[ -z "$host" ]]; then## title: Generate Show Page
## description: This script will generate a show page for the podcast
## author: Sam Greenwood
## date: 2023-06-05
## version: beta 0.1
## usage: ./generate-show-page.sh
## bash_version: 5.0.17(1)-release
## license: MIT License

## file shuld be created in /home/sam/samgoesbts.com/content/episodes/episde_create.md
## Generate Show Notes

echo "---"
echo "Date: \"$(date --utc +%FT%TZ)\""

## Get the description from user input
echo "Description: \"$(read -p "Description: " desc; echo $desc)\""

## Prompt for the title
echo "Title: \"$(read -p "Title: " title; echo $title)\""
## save title as contigous variable with dashes instead of spaces
title=$(echo $title | sed -e 's/ /-/g' | tr '[:upper:]' '[:lower:]')

## prompt for episode number
echo "episode: \"$(read -p "Episode: " episode; echo $episode)\""

## prompt for image
echo "image: \"$(read -p "Image: " image; echo $image)\""

## prompt for explicit (select from yes/no in menu bash)
PS3='Explicit? '
select explicit in yes no
do
  case $explicit in
    yes)
      echo "explicit: \"yes\""
      break
      ;;
    no)
      echo "explicit: \"no\""
      break
      ;;
    *)
      echo "invalid option $REPLY"
      ;;
  esac
done

## prompt for hosts
echo "hosts:"
while true; do
    read -p "Host: " host
    if [[ -z "$host" ]]; then
        break
    fi
    echo "  - $host"
done  

## prompt for path to images
echo "images:"
while true; do
    read -p "Image: " image
    if [[ -z "$image" ]]; then
        break
    fi
    echo "  - $image"
done

## prompt for series
echo "series:"
while true; do
    read -p "Series: " series
    if [[ -z "$series" ]]; then
        break
    fi
    echo "  - $series"
done

## prompt for tags
echo "tags:"
while true; do
    read -p "Tag: " tag
    if [[ -z "$tag" ]]; then
        break
    fi
    echo "  - $tag"
done

## prompt for youtube video
echo "youtube: $(read -p "YouTube: " youtube; echo $youtube)"


        break
    fi
    echo "  - $host"
done  

## prompt for path to images
echo "images:"
while true; do
    read -p "Image: " image
    if [[ -z "$image" ]]; then
        break
    fi
    echo "  - $image"
done

## prompt for series
echo "series:"
while true; do
    read -p "Series: " series
    if [[ -z "$series" ]]; then
        break
    fi
    echo "  - $series"
done

## prompt for tags
echo "tags:"
while true; do
    read -p "Tag: " tag
    if [[ -z "$tag" ]]; then
        break
    fi
    echo "  - $tag"
done

## prompt for youtube video
echo "youtube: $(read -p "YouTube: " youtube; echo $youtube)"

## end of file
echo "---"

## Print out the variables to the user in simple command line format
echo "Title: $title" 
echo "Description: $desc"
echo "Episode: $episode"
echo "Image: $image"
echo "Explicit: $explicit"
echo "Hosts: $host"
echo "Images: $image"
echo "Series: $series"
echo "Tags: $tag"
echo "YouTube: $youtube"

## create file
touch /home/sam/samgoesbts.com/content/episodes/$title.md
