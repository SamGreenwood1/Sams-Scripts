gitcron() {
    local exclude="~/sites/in-progress ~/sites/keyoxide ~/sites/testing"
    
    category_dir=$HOME/sites/
    parent_dir=$(basename $(dirname $(dirname "$1")))
    site_name=$(basename $(dirname "$1"))

    # Push function
    push() {
        local repo="$1"
        echo "Pushing $repo..."
        cd "$repo" || return
        git add . && git commit -m "Auto commit $(date +'%Y-%m-%d %H:%M:%S')" 
        git push origin master
        cd - >/dev/null || return
    }

    # Determine branch based on site name
    if [[ "cale shelby steve yael" =~ $site_name ]]; then
        branch=$site_name
    else
        branch="main"
    fi

    # Main function
    main() {
        if [ -d "$1" ]; then
            if [ -z "$exclude" ] || ! echo "$exclude" | grep -q "$1"; then
                push "$1"
            fi
        else
            for d in "$1"/*; do
                main "$d"
            done
        fi
    }
}
