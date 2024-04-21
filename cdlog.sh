#!/bin/bash

# Function to log absolute path after cd command
log_cd_path() {
  # Get absolute path from previous command (cd) exit status
  local target_path="$($? -eq 0 && echo $(pwd -P))"
  if [[ -n "$target_path" ]]; then
    echo "$(date +'%Y-%m-%d %H:%M:%S')  $target_path" >> ~/.cd_history
  fi
}

# Enable history appending
shopt -s histappend

# Trap successful cd (exit status 0) to log path
trap log_cd_path EXIT

# Informative message
echo "Logging absolute paths after successful cd commands to ~/.cd_history"

# Script runs in background
