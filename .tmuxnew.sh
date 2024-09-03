#!/bin/bash

# Name: tmuxset.sh      
# Author: Sam Greenwood
# Date: 2024-05-05      
# Version: a0.2 r1
# Description: A script to manage tmux sessions
# Shell: bash

tmuxset() {
    categories={"personal" "camp" "rempath" "family" "other"}
    a2CertDir="/etc/letsencrypt" a2SitesDir="/etc/apache2/sites-available" a2WWWDir="/var/www"
    sitePaneDIRs={"sites" "files" "www"} manPaneDIRs={"a2SitesDir" "a2CertDir" "a2WWWDir"} 
    i=0 profile="$1" 

    if [ "$1" != "info" ]; then     # If the first argument is not info
        echo -e "Categories: ${categories[@]}\nYou entered: $1" ; else
        echo -e "SIte Path: $sitePathDIR\nPane Directories: ${sitePaneDIRs[@]}\nManagement Pane Directories: ${manPaneDIRs[@]}" ; fi 

    case "$@" in
        ps)
            local dirPS="~/.site-users/personal/"   profile="personal"
            pn1="sites" pn2="files" pn3="www"
            echo -e "Profile: $profile\nDirectory: $dirPS"
            # if session does not exist, create it
            if [ -z "$(tmux ls | grep "ps")" ]; then defaultTemplate "ps" ; else tmux attach -t "ps" ; fi ;;
        info) echo -e "Window: $window\nPane: $pane\nPane Directory: $paneDir\nSite Path Directory: $sitePathDIR\nSite Pane Directories: ${sitePaneDIRs[@]}\nManagement Pane Directories: ${manPaneDIRs[@]}" ;;
        management)         # Create a new tmux session (no .site-users directory this profile is for server management not stuff related to specific sites stuff like apache2, letsencrypt, etc.)
            local window="management:0" profile="management"
            echo -e "Profile: $profile\nWindow: $window"
            if [ -z "$(tmux ls | grep "management")" ]; then
                pn1="apache2" pn2="letsencrypt" pn3="other" pn1Dir="/etc/apache2/sites-available" pn2Dir="/etc/letsencrypt" pn3Dir="/var/www"
                tmux new -d -s management
                tmux rename-window -t "$window" "main"
                for pane in "${manPaneDIRs[@]}"; do
                    tmux splitw -h -p 50 -t "$window" \; splitw -v -p 50 -t "$window" \;
                    tmux selectp -t "$window" -T "$pane" ; 
                    tmux send-keys -t "$window" "cd ${pane}Dir" Enter ; done ; setupAttach "management" ; else tmux attach -t "management" ; fi ;; 
        all)
            if [ -z "$(tmux ls | grep "all")" ]; then all ; else tmux attach -t "all" ; fi ;;
        *)
            profile="$1"
            if [ -z "$(tmux ls | grep "$1")" ]; then
                defaultTemplate "$1" "$profile" ; fi ;;
    esac

    defaultTemplate() {
        local i=0
        # if session is management use the management panes or if it is personal or ps use the sitePaneDIRs if passed from all f
       case profile in
            management)
                local pn1="apache2" pn2="letsencrypt" pn3="other"
                tmux new -d -s "$1" -c /etc/apache2
                for pane in "${manPaneDIRs[@]}"; do
                    tmux splitw -h -p 50 -t "$1:0.$i" \; splitw -v -p 50 -t "$1:0.$((i+1))" \;
                    tmux selectp -t "$1:0.$i" -T "$pane" ; i=$((i+1)) ; done ; setupAttach "$1" ;;
            *)
                local pn1="sites" pn2="files" pn3="www"
                tmux new -d -s "$1" -c ~/.site-users/$category/$pn1 -n "$profile"
                for pane in "${sitePaneDIRs[@]}"; do
                    tmux splitw -h -p 50 -t "$1:0.$i" \; splitw -v -p 50 -t "$1:0.$((i+1))" \;
                    tmux selectp -t "$1:0.$i" -T "$pane" ; i=$((i+1)) ; done ; setupAttach "$1" ;;
        esac
    }

    management() {
        local pn1="apache2" pn2="letsencrypt" pn3="other"
        tmux splitw -h -p 50 -t "all:0.0" \; splitw -v -p 50 -t "all:0.1" \;
        tmux selectp -t "all:0.0" -T "apache2" \; selectp -t "all:0.1" -T "letsencrypt" \; selectp -t "all:0.2" -T "other"
        tmux send-keys -t "all:0.1" "cd /etc/letsencrypt" Enter
        tmux send-keys -t "all:0.2" "cd /var/www" Enter
    }

    all() {
        local pn1="sites" pn2="files" pn3="www"
        echo -e "Profile: all\nPane 1: $pn1\nPane 2: $pn2\nPane 3: $pn3"
        tmux new -d -s "all" -c ~/.site-users/personal/sites/
        for category in "${categories[@]}"; do
            if [ ${categories[0]} == "$category" ]; then
                tmux rename-window -t "all:0" "personal"
                tmux splitw -h -p 50 -t "all:$category.0" \; splitw -v -p 50 -t "all:$category.1" \;
                tmux selectp -t "all:$category.0" -T "sites" \; selectp -t "all:$category.1" -T "files" \; selectp -t "all:$category.2" -T "www"
                tmux send-keys -t "all:$category.1" "cd ~/.site-users/$category/$pn2" Enter
                tmux send-keys -t "all:$category.2" "cd ~/.site-users/$category/$pn3" Enter ; else
                tmux new-window -t "all" -n "$category" -c ~/.site-users/$category/sites/
                tmux splitw -h -p 50 -t "all:$category.0" \; splitw -v -p 50 -t "all:$category.1" \;
                tmux selectp -t "all:$category.0" -T "sites" \; selectp -t "all:$category.1" -T "files" \; selectp -t "all:$category.2" -T "www"
                tmux send-keys -t "all:$category.1" "cd ~/.site-users/$category/$pn2" Enter
                tmux send-keys -t "all:$category.2" "cd ~/.site-users/$category/$pn3" Enter
                tmux selectp -t "all:$category.0" ; fi
        done
        tmux new-window -t "all" -n "management" -c /etc/apache2
        management ; tmux selectp -t "all:0.0"
    }
    
    setupAttach() {
        tmux set -g pane-border-status bottom
        tmux set -g mouse on
        tmux set -g default-terminal "screen-256color"
        tmux selectp -t "$1:0.0"
        if [ $# -eq 2 ] && [ "$2" == "-y" ]; then tmux attach -t "$1"; else
            echo -e "Session: $1 created successfully.\nUse 'tmux a -t $1' to attach to the session." ; fi
    }
}