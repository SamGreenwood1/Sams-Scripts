#!/bin/bash

# Name: Tmux Manager
# Description: A script to manage tmux sessions
# Author: Sam Greenwood
# Date: 2024-05-08
# Version: a0.1 r1
# Shell: bash

# Source external variables and functions
if [ -f ~/.startup/vars.sh ]; then
    . ~/.startup/vars.sh
else
    echo "Error: ~/.startup/vars.sh not found."
    exit 1
fi

# Function to manage tmux sessions
tman() {
    case "$1" in
        -n|--new)
            case "$2" in
                all|management|personal|ps|camp|rempath|family|other)
                    . ~/scripts/tmuxset.sh "$2"
                ;;
                build)
                    tmuxset all
                    tmuxset management
                    tmuxset personal
                    tmuxset camp
                    tmuxset rempath
                    tmuxset family
                    tmuxset other
                ;;
                "")
                    echo "Usage: tman --new <session>" && return 1
                ;;
                *)
                    echo "Invalid session type: $2" && return 1
                ;;
            esac

            if tmux has-session -t "$2" 2>/dev/null; then
                tmux attach -t "$2"
            else
                tmux new -s "$2" -d
            fi
        ;;
        -s|--silent)
            case "$2" in
                all|management|personal|camp|rempath|family|other)
                    tn "$2" -s
                ;;
                build)
                    tn all -s
                    tn management -s
                    tn personal -s
                    tn camp -s
                    tn rempath -s
                    tn family -s
                    tn other -s
                ;;
                test)
                    tn test
                ;;
                "")
                    echo "Usage: tman --silent <session>" && return 1
                ;;
                *)
                    echo "Invalid session type: $2" && return 1
                ;;
            esac
        ;;
        ls)
            case "$2" in
                -a|--all)
                    echo -e "All tmux sessions:\n$(tmux list-sessions)\nWindows:\n$(tmux lsw -a)\nPanes:\n$(tmux lsp -a)"
                ;;
                -l)
                    tmux ls
                ;;
                *)
                    tmux ls | cut -d':' -f1
                ;;
            esac
        ;;
        reset)
            resetSessions
        ;;
        test)
            for category in "${categories[@]}"; do
                tn "$category" -s
            done
        ;;
        h|help|-h|--help)
            if [ -f ~/.startup/help.sh ]; then
                . ~/.startup/help.sh tman
            else
                echo "Help script not found!"
                return 1
            fi
        ;;
        k|kill|-k|--kill)
            if [ -z "$2" ]; then
                echo "Usage: tman --kill <session>" && return 1
            fi
            tkill "$2"
        ;;
        ka|kill-all|--kill-all)
            killSessions
        ;;
        "")
            echo "Usage: tman <command> [options]"
        ;;
        *)
            echo "Invalid option. Use 'tman --help' for more information."
        ;;
    esac
}

# Function to reset all tmux sessions
resetSessions() {
    echo -e "\nResetting all tmux sessions...\n"
    tmls | cut -d':' -f1 | while read -r session_name; do
        tmux kill-session -t "$session_name"
    done
    echo -e "All tmux sessions have been killed.\n\n"
    for category in "${categories[@]}"; do
        if ! tmux has-session -t "$category" 2>/dev/null; then
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

# Start script
tman "$@"
