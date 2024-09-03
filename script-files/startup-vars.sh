# Name: Tmux Manager Variables
# Description: Variables for the tmux scripts
# Author: Sam Greenwood
# Created: 2024-05-19
# Last Updated: 2024-05-19
# Version: a0.1 r1

# vars for tmuxset.sh
tmuxsetVars() {
    categories=("personal" "camp" "rempath" "family" "other")
    a2CertDir=("/etc/letsencrypt")
    a2SitesDir="/etc/apache2/sites-available"
    a2WWWDir="/var/www"
    sitePaneDIRs=("sites" "files" "www")
    manPaneDIRs=("a2SitesDir" "a2CertDir" "a2WWWDir")
    ta=$(tmux attach -t)
    silentCategories=("personal" "camp" "rempath" "family" "other" "management" "all" "ps")
    infoLine="Profile: $profile\nWindow: $window\nPane Directory: $paneDir"
    split=$(tmux splitw -h -p 50 -t $w1 /; splitw -v -p 50 -t $w2)
    # tmn=$(tmux new -d -s)
    SPVs="~/.site-users/$category"
    idnc="$profile:$category.$i"
    idc="$profile:$category"
    i=0
    profile="$1"
    tmrn=$(tmux rename-window -t)
    tms=$(tmux selectp -t)
    tsk=$(tmux send-keys -t)
    idn="$profile:$category.$i"
    tmCDPathVarS=$(cd $sitePathDIR/$pane)
    tmCDPathVarM=$(cd $manPathDIR/$pane)
    tmsg=$(tmux set -g)
    # 4cat="for category in \"${categories[@]}\"; do"
    dt="default-terminal"
    pbs="pane-border-status"
    eea=$(echo -e "Session $1 created successfully.")
}

# vars for tman.sh
tmanVars() {
    panes=("sites" "files" "www")
    usage="Usage: tman [new|ls|reset]"
    ee=$(echo -e)
    categories=("personal" "camp" "rempath" "family" "other")
    killS="killSessions"
    killW="killWindows"
    killP="killPanes"
    killA="killAll"
}

# vars for both
varsAll() {
    tn=$(tmux new -d -s)
    tk=$(tmux kill-session -t)
    tns=$(tmux new-session -d -s)
    pr=$(echo "$profile")
    w1="$1:$category"
    w2="$1:$category.1)"
    id="$profile:$catNum"
    idc="$profile:$category"
    tnmm=$(tmux new -d -s management)
    ts=$(tmuxset)
}
