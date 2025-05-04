#!/bin/bash

# Ensure the script is running with bash, not sh or dash
if [ -z "$BASH_VERSION" ]; then
    exec bash "$0" "$@"
fi

# Name: tmux_manager.sh
# Author: Sam Greenwood
# Date: 2024-05-05
# Version: a0.3 r1
# Description: A script to manage tmux sessions
# Shell: bash

# Use the dot command for portability
. ~/.startup/vars.sh

# Define missing arrays (customize as needed)
silentCategories=("personal" "management" "camp" "rempath" "family" "other")
categories=("personal" "management" "camp" "rempath" "family" "other")

# Check for tmux dependency
if ! command -v tmux >/dev/null 2>&1; then
    echo "Error: tmux is not installed or not in PATH." >&2
    exit 1
fi

# Stub missing functions (fill in or source as needed)
tn() { echo "[stub] tn $@"; }
tmn() { echo "[stub] tmn $@"; }
tms() { echo "[stub] tms $@"; }
tsk() { echo "[stub] tsk $@"; }
tmrn() { echo "[stub] tmrn $@"; }
tmsg() { echo "[stub] tmsg $@"; }
ta() { echo "[stub] ta $@"; }
tkill() { echo "[stub] tkill $@"; }
tmls() { tmux ls; }
4PinSDir() { echo "[stub] 4PinSDir $@"; }
split() { echo "[stub] split $@"; }
4cat() { echo "[stub] 4cat $@"; }
buildAll() { echo "[stub] buildAll $@"; }
customInteractive() { echo "[stub] customInteractive $@"; }
eea() { echo "[stub] eea $@"; }

tmux_manager() {
    case "$1" in
        ps)
            local profile="personal"
            defaultTemplate "ps" "$profile"
        ;;
        info)
            echo -e "Window: ${window:-N/A}\nPane: ${pane:-N/A}\nPane Directory: ${paneDir:-N/A}\nSite Path Directory: ${sitePathDIR:-N/A}"
            echo -e "Site Pane Directories: ${sitePaneDIRs[*]:-N/A}\nManagement Pane Directories: ${manPaneDIRs[*]:-N/A}"
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
            if [ -z "$2" ]; then
                echo "Usage: tmux_manager --new <session>"
                return 1
            fi

            case "$2" in
                all|management|personal|camp|rempath|family|other)
                    tn "$2"
                ;;
                build)
                    tn all
                    tn management
                    tn personal
                    tn camp
                    tn rempath
                    tn family
                    tn other
                ;;
                *)
                    echo "Invalid session type. Use 'tmux_manager --help' for more information."
                    return 1
                ;;
            esac

            if [ -z "$(tmux ls | grep "$2")" ]; then
                tmux new -s "$2" -d
            else
                tmux attach -t "$2"
            fi
        ;;
        -s|--silent)
            if [ -z "$2" ]; then
                echo "Usage: tmux_manager --silent <session>"
                return 1
            fi

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
                *)
                    echo "Invalid session type. Use 'tmux_manager --help' for more information."
                    return 1
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
            echo -e "\nResetting all tmux sessions...\n"
            tmux ls | cut -d':' -f1 | while read -r session; do
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
    local paneDir="${sitePathDIR}/${pane:-N/A}"
    echo "Function: defaultTemplate"

    if [ "$profile" != "all" ]; then
        if [ "$3" == "-s" ]; then
            build "$1"
        else
            echo -e "${infoLine:-N/A}"
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
            for i in {0..3}; do
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
    for i in {0..3}; do
        tms "$idnc" /
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
    tmsg "$dt" "screen-256color"
    tmsg "$pbs" "top"
    tmsg "mouse on"
    tms "$1:0.0"
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
}

# Call the tmux_manager function with all the provided arguments
tmux_manager "$@"