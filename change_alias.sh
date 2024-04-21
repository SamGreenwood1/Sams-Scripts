#!/bin/bash

change_alias_name() {
  local old_alias="$1"
  local new_alias="$2"

  if alias "$old_alias" &> /dev/null; then
    local old_command=$(alias "$old_alias" | sed -E 's/^alias [^=]+=//')
    unalias "$old_alias" || { echo "Failed to remove alias '$old_alias'"; exit 1; }
    alias "$new_alias=$old_command"
    echo "Alias '$new_alias' set to the same command as '$old_alias'."
  else
    echo "Error: Alias '$old_alias' does not exist."
    exit 1
  fi
}

change_alias_command() {
  local alias_name="$1"
  local new_command="$2"

  unalias "$alias_name" &> /dev/null || echo "Alias '$alias_name' does not exist."
  alias "$alias_name=$new_command"
  echo "Alias '$alias_name' set to '$new_command'."
}

usage() {
  echo "Usage: $0 [OPTIONS]"
  echo "Options:"
  echo "  -n, --name <old_alias> <new_alias>   Change the alias name while inheriting the command."
  echo "  -c, --command <alias> <new_command>  Change the alias command."
  exit 1
}

if [ $# -eq 0 ]; then
  usage
fi

while [ $# -gt 0 ]; do
  case "$1" in
    -n|--name)
      shift
      change_alias_name "$1" "$2"
      shift 2
      ;;
    -c|--command)
      shift
      change_alias_command "$1" "$2"
      shift 2
      ;;
    *)
      usage
      ;;
  esac
done
