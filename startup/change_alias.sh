#!/bin/bash

# Name: change_alias    Author: Sam Greenwood   Description: Change an alias
# Arguments: -n|--name <alias_name> -c|--command <new_value> -h|--help
# Example: change_alias -n old_alias -c new_alias
# Date: 2024-05-17    Updated: 2024-05-17     Version: a0.1


change_alias() {
  local alias_name="$2"
  local new_value="$3"

  case "$1" in
    -n|--name)
      if alias "$alias_name" &> /dev/null; then
        local old_command=$(alias "$alias_name" | sed -E 's/^alias [^=]+=//')
        unalias "$alias_name" || { echo "Failed to remove alias '$alias_name'"; exit 1; }
        alias "$new_value=$old_command"
        echo "Alias '$new_value' set to the same command as '$alias_name'."
      else
        echo "Error: Alias '$alias_name' does not exist."
        exit 1
      fi
      ;;
    -c|--command)
      unalias "$alias_name" &> /dev/null || echo "Alias '$alias_name' does not exist."
      alias "$alias_name=$new_value"
      echo "Alias '$alias_name' set to '$new_value'."
      ;;
    -h|--help)
      \cat ~/.startup/help/change_alias
      ;;
    *)
      echo "Invalid option: $option"
      exit 1
      ;;
  esac
}