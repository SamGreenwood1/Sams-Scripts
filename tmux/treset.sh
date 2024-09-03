#!/bin/bash

# List all tmux sessions
tmux ls | cut -d: -f1 |

# Loop through each session name and kill it
while read -r session_name; do
  tmux kill-session -t "$session_name"
  tnew "$session_name"
done
