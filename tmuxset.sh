#!/bin/bash

# Name: tmuxset.sh
# Author: Sam Greenwood
# Date: 2024-07-22
# Version: a0.3 r1
# Description: A script to manage tmux sessions
# Shell: bash

# Source external variables
. ~/scripts/script-files/startup-vars.sh

# Function to manage tmux sessions
tmuxset() {
    if [ "$1" != "info" ]; then
        echo -e "Categories: ${categories[@]}\nYou entered: $1"
    else
        echo -e "Site Path: $sitePathDIR\nPane Directories: ${sitePaneDIRs[@]}\nManagement Pane Directories: ${manPaneDIRs[@]}"
    fi

    case "$1" in
        ps)
            defaultTemplate "ps" "personal"
#            local profile="personal"
#            defaultTemplate "ps" "$profile"
            ;;
        -s|--silent)
            echo "Silent mode"
            for category in "${categories[@]}" "management" "all" "ps"; do
                tn "$category" -s
            done
            tn ls -a
            ;;
        info)
            echo -e "Window: $window\nPane: $pane\nPane Directory: $paneDir\nSite Path Directory: $sitePathDIR"
            echo -e "Site Pane Directories: ${sitePaneDIRs[@]}\nManagement Pane Directories: ${manPaneDIRs[@]}"
            ;;
        m|management)
            local profile="management"
            defaultTemplate "management" "$profile"
            ;;
        all)
            tmux new -d -s "all"
            buildAll
            ;;
        "")
            echo "Usage: tmuxset [profile]"
            ;;
        *)
            local profile="$1"
            defaultTemplate "$1" "$profile"
            ;;
    esac
}

# Function to apply a default template
defaultTemplate("ps" "personal") {
    local profile="$2" window="$1:0"
    paneDir="$sitePathDIR/$pane"  # Corrected to use a global variable

    echo "Function: defaultTemplate"

    if [ "$profile" != "all" ]; then
        if [ "$3" == "-s" ]; then
            build "$1"
        else
            echo -e "Profile: $profile\nWindow: $window\nPane Directory: $paneDir"
            build "$1"
        fi
    fi
}

# Function to build tmux panes and windows
build() {
    case $profile in
        management)
            management "$1"
            ;;
        *)
            tmux new -d -s "$profile"
            for pane in "${sitePaneDIRs[@]}"; do
                tmux new-window -t "$1"
                tmux splitw -h -p 50 -t "$1:0"
                tmux splitw -v -p 50 -t "$1:0.1"
                tmux selectp -t "$1:0.0" -T "$pane"  # Fixed indexing
                tmux send-keys -t "$1:0.0" "cd $sitePathDIR/$pane" Enter
            done
            setupAttach "$1"
            ;;
    esac
}

# Function for management profile
management() {
    echo "Profile: management"
    tmux new -d -s "management"
    tmux rename-window -t "management:0" "main"
    tmux splitw -h -p 50 -t "management:0"
    tmux splitw -v -p 50 -t "management:0.1"
    local i=0
    for pane in "${manPaneDIRs[@]}"; do
        tmux selectp -t "management:0.$i" -T "$pane"
        tmux send-keys -t "management:0.$i" "cd $sitePathDIR/$pane" Enter
        i=$((i+1))
    done
    setupAttach "management"
}

# Function to build all categories
buildAll() {
    local window="all:0" winNum=0
    local i=0

    echo "Function: buildAll"
    tmux rename-window -t "all:0" "Personal"

    for category in "${categories[@]}"; do
        tmux splitw -h -p 50 -t "all:$category"
        tmux splitw -v -p 50 -t "all:$category.1"
        for pane in "${sitePaneDIRs[@]}"; do
            tmux selectp -t "all:$category.$i" -T "$pane"
            tmux send-keys -t "all:$category.$i" "cd $sitePathDIR/$pane" Enter
            i=$((i+1))
        done
        if [ $i -eq 3 ]; then
            winNum=$((winNum+1))
            tmux new-window -t "all:$winNum"
            i=0
        fi
    done
    tmux kill-window -t "all:5"  # Corrected from 'close-window'
    management4All
}

# Function to create a management window for 'all' session
management4All() {
    local i=0
    tmux new-window -t "all:$(expr $winNum + 1)" -n "management"
    tmux splitw -h -p 50 -t "all:management"
    tmux splitw -v -p 50 -t "all:management.1"
    for pane in "${manPaneDIRs[@]}"; do
        tmux selectp -t "all:management.$i" -T "$pane"
        tmux send-keys -t "all:management.$i" "cd $sitePathDIR/$pane" Enter
        i=$((i+1))
    done
    echo "Management window created."
    setupAttach "all"
}

# Function to set up and attach tmux session
setupAttach() {
    tmux set -g pane-border-status bottom
    tmux set -g mouse on
    tmux set -g default-terminal "screen-256color"
    tmux selectp -t "$1:0.0"
    if [ "$3" == "-y" ]; then
        echo -e "Session: $1 created successfully.\nYou are about to attach to the session."
        tmux attach -t "$1"
    else
        echo -e "Session: $1 created successfully.\nUse 'tmux a -t $1' to attach to the session."
    fi
    return 0
}
