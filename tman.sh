#!/bin/bash

# Name: Tmux Manager
# Description: A script to manage tmux sessions
# Author: Sam Greenwood
# Date: 2024-05-08
# Version: a0.1 r1
# Shell: bash

# Source external variables
. ~/.startup/vars.sh
# . ~/scripts/script-files/vars.sh
# . ~/scripts/script-files/startup-vars.sh

# Function to manage tmux sessions
tman() {
    case "$1" in
        -n|--new)
            case "$2" in
                all) tmuxset "$2" ;;
                management) tmuxset management ;;
                personal|ps) tmuxset personal ;;
                camp) tmuxset camp ;;
                rempath) tmuxset rempath ;;
                family) tmuxset family ;;
                other) tmuxset other ;;
                build) tmuxset all && tmuxset management && tmuxset personal && tmuxset camp && tmuxset rempath && tmuxset family && tmuxset other ;;
                "") echo "Usage: tman new <session>" && return 1 ;;
                *) tn "$2" ;;
            esac
            if [ -z "$(tmux ls | grep "$2")" ]; then
                tmux new -s "$2" -d
            else
                tmux attach -t "$2"
            fi
        ;;
        -s|--silent)
            case "$2" in
                all|management|personal|camp|rempath|family|other) tn "$2" -s ;;
                build) tn all -s && tn management -s && tn personal -s && tn camp -s && tn rempath -s && tn family -s && tn other -s ;;
                test) tn test ;;
                "") echo "Usage: tman silent <session>" && return 1 ;;
                *) tn "$2" -s ;;
            esac
        ;;
        ls)
            case "$2" in
                -a|--all) echo -e "All tmux sessions:\n$(tmux list-sessions)\nWindows:\n$(tmux lsw -a)\nPanes:\n$(tmux lsp -a)" ;;
                -l) tmux ls ;;
                *) tmux ls | cut -d':' -f1 ;;
            esac
        ;;
        reset)
            resetSessions
        ;;
        test)
            for category in "${categories[@]}"; do tn "$category" -s ; done
        ;;
        h|help|-h|--help)
            . ~/.startup/help.sh tman
        ;;
        k|kill|-k|--kill)
            if [ -z "$2" ]; then
                echo "Usage: tman kill <session>" && return 1
            fi
            tkill "$2"
        ;;
        ka|kill-all|--kill-all)
            killSessions
        ;;
        "")
            ;;
        *)
            echo "Invalid option. Use 'tman --help' for more information."
        ;;
    esac
}

# # Function to build all tmux sessions
# build() {
#     tn all
#     tn management
#     tn personal
#     tn camp
#     tn rempath
#     tn family
#     tn other
#     tman ls -a
# }

# Function to reset all tmux sessions
resetSessions() {
    echo -e "\nResetting all tmux sessions...\n"
    tmls | cut -d':' -f1 | while read -r session_name; do
        tmux kill-session -t "$session_name"
    done
    echo -e "All tmux sessions have been killed.\n\n"
    for category in "${categories[@]}"; do
        if [ -z "$(tmux ls | grep "$category")" ]; then
            tn "$category"
        fi
    done
}

# Function to kill all tmux sessions
killSessions() {
    tmls | cut -d':' -f1 | while read -r session_name; do
        tkill "$session_name"
    done
}

# Call the tman function with the provided argument
tman "$@"