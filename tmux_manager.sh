#!/bin/bash

# Name: tmux_manager.sh
# Author: Sam Greenwood
# Date: 2024-05-05
# Version: a0.3 r1
# Description: A script to manage tmux sessions
# Shell: bash

# Source external variables and functions
tmux_manager() {
    case "$1" in
        ps)
            local profile="personal"
            defaultTemplate "ps" "$profile"
        ;;
        info)
            echo -e "Window: $window\nPane: $pane\nPane Directory: $paneDir\nSite Path Directory: $sitePathDIR"
            echo -e "Site Pane Directories: ${sitePaneDIRs[@]}\nManagement Pane Directories: ${manPaneDIRs[@]}"
        ;;
        m|management)
            local profile="management"
            defaultTemplate "management" "$profile"
        ;;
        test)
            for category in "${silentCategories[@]}"; do
                tn "$category" -s
            done
        ;;
        all)
            tmux new -d -s "all"
            all
        ;;
        -n|--new)
            case "$2" in
                all|management|personal|camp|rempath|family|other) tn "$2" ;;
                build) 
                    tn all
                    tn management
                    tn personal
                    tn camp
                    tn rempath
                    tn family
                    tn other
                ;;
                "") 
                    echo "Usage: tmux_manager --new <session>"
                    return 1
                ;;
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
                build)
                    tn all -s
                    tn management -s
                    tn personal -s
                    tn camp -s
                    tn rempath -s
                    tn family -s
                    tn other -s
                ;;
                test) tn test ;;
                "") 
                    echo "Usage: tmux_manager --silent <session>"
                    return 1
                ;;
                *) tn "$2" -s ;;
            esac
        ;;
        ls)
            case "$2" in
                -a|--all)
                    echo -e "All tmux sessions:\n$(tmux list-sessions)\nWindows:\n$(tmux lsw -a)\nPanes:\n$(tmux lsp -a)"
                ;;
                -l) tmux ls ;;
                *) tmux ls | cut -d':' -f1 ;;
            esac
        ;;
        reset)
            echo -e "\nResetting all tmux sessions...\n"
            for session in $(tmux ls | cut -d':' -f1); do
                tmux kill-session -t "$session"
            done
            echo -e "All tmux sessions have been reset.\n"
            for category in "${categories[@]}"; do
                if [ -z "$(tmux ls | grep "$category")" ]; then
                    tn "$category"
                fi
            done
        ;;
        h|help|-h|--help)
            . ~/.startup/help.sh tmux_manager
        ;;
        k|kill|-k|--kill)
            if [ -z "$2" ]; then
                echo "Usage: tmux_manager --kill <session>"
                return 1
            fi
            tkill "$2"
        ;;
        ka|kill-all|--kill-all)
            killSessions
        ;;
        int)
            if [ -z "$2" ]; then
                echo "Usage: tmux_manager int <session>"
                return 1
            fi
            customInteractive "$2"
        ;;
        "")
            echo "Usage: tmux_manager <command>"
        ;;
        *)
            echo "Invalid option. Use 'tmux_manager --help' for more information."
        ;;
    esac
}

defaultTemplate() {
    local profile="$2"
    local window="$1:0"
    local paneDir="$sitePathDIR/$pane"
    echo "Function: defaultTemplate"

    if [ "$profile" != "all" ]; then
        if [ "$3" == "-s" ]; then
            build "$1"
        else
            echo -e "$infoLine"
        fi
        return 0
    fi
}

build() {
    case $profile in
        management)
            management "$1"
        ;;
        *)
            tmn "$profile"
            4PinSDir
            split
            for ((i=0; i<4; i++)); do
                tms "$profile:$catNum.$i"
                tsk "$tmCDPathVarS" Enter
            done
            setupAttach "$1"
        ;;
    esac
}

management() {
    tmn "management"
    4PinSDir
    split
    tmrn "management:0" "main"
    tms "management:main.0" /
    tsk "$tmCDPathVarM" Enter
    setupAttach "$1"
}

all() {
    local window="all:0"
    local winNum=0
    local i=0
    echo "Function: all"
    buildAll "all"
    tmn all
    4cat
    split
    4PinSDir
    for ((i=0; i<4; i++)); do
        tms $idnc /
        tsk "$tmCDPathVarS" Enter
    done
    if [ $i -eq 3 ]; then
        winNum=$((winNum+1))
        tmux new-window -t "all:$winNum"
        i=0
    fi
    tmux close-window -t "all:5"
    management4All "all"
}

management4All() {
    tmn "management"
    4PinSDir
    split
    tmrn "management:0" "main" /
    tms "management:main.0" /
    tsk "$tmCDPathVarM" Enter
    echo "All tmux sessions have been created."
}

setupAttach() {
    tmsg $dt "screen-256color"
    tmsg $pbs "top"
    tmsg mouse on
    tms $1:0.0
    if [ "$3" == "-y" ]; then
        $eea "You are about to attach to the session."
        ta "$1"
    else
        $eea "Use 'ta $1' to attach to the session."
    fi
}

killSessions() {
    tmls | cut -d':' -f1 | while read -r session_name; do
        tkill "$session_name"
    done
} < ~/.startup/vars.sh
