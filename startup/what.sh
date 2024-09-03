#!/bin/bash

# Name: what    # Author: Sam Greenwood     # Description: what is a function that determines the type of a command, alias, function, file, or application. It then provides information about the type of the command, alias, function, file, or application. If the type is an alias, it will provide the alias details and the file details. If the type is an application, it will provide the package details and the version of the application. If the type is a function, it will provide the function details. If the type is a file, it will provide the file details. If the type is none of the above, it will provide an error message. The function also has a help option that provides information on how to use the function.
# Arguments: $1: The command, alias, function, file, or application to determine the type of.
# Options: -h, --help: Provides information on how to use the function.
# Example: what ls      # Date: 2024-05-17      # Updated: 2024-05-17   # Version: a0.0.1

what() {
    setType() {
        type=$(type -t "$1")
        if [ "$type" = "alias" ]; then
            if [[ "$(alias "$1" | cut -d"=" -f2 | cut -d"'" -f2)" == *".sh" ]] || [[ "$(alias "$1" | cut -d"=" -f2 | cut -d"'" -f2)" == *".bash" ]]; then
                type="alias2script"
            fi
        fi
        case $type in
            alias)
                echo -e "Alias: $1 is defined as: $(alias "$1")"
                ;;
            function)
                echo "Function: $1 is defined as:"
                # if version is available from the function print it (find it using grep or awk or sed)
                declare -f "$1"
                ;;
            file)
                echo "File: $1 is stored in: $(readlink -f "$1")"
                script "$1"
                ;;
            application)
                whatis "$1" && echo "Package: $1 is stored in: $(which "$1")"
                if [ -x "$(command -v "$1")" ]; then
                    echo "$1 version:" "$("$1" --version | head -1 | cut -d" " -f3)"
                fi
                ;;
            alias2script)
                alias "$1" | cut -d"=" -f2 | cut -d"'" -f2
                echo -e "Alias Details: $(alias "$1")\nFile Details: \nLocation: $(readlink -f "$(alias "$1" | cut -d"=" -f2 | cut -d"'" -f2)")"
                # if version is available append it to the output of the last command
                if [ -x "$(command -v "$1")" ]; then
                    echo "$1 version:" "$("$1" --version | head -1 | cut -d" " -f3)"
                fi
                ;;
            script)
                echo "Script: $1 is stored in: $(readlink -f "$1")"
                ;;
            *)
                echo "Error: $1 is not an alias, function, file, or application."
                ;;
        esac
    }

    script() {
        script=$(find "$HOME/scripts" -type f -name "$1*.sh" -o -name "$1*.bash" | head -n 1)
        [[ ! -d "$HOME/.tmp" ]] && mkdir "$HOME/.tmp"

        head -n 10 "$script" > "$HOME/.tmp/scinfo_tmpfile" && head -n 10 "$HOME/.tmp/scinfo_tmpfile"

        name=$(grep -oP '(?<=Name: ).*' "$script") # Name
        author=$(grep -oP '(?<=Author: ).*' "$script") # Author
        date=$(grep -oP '(?<=Date: ).*' "$script") # Date
        version=$(grep -oP '(?<=Version: ).*' "$script") # Version
        description=$(grep -oP '(?<=Description: ).*' "$script") # Description
        shell=$(grep -oP '(?<=Shell: ).*' "$script") # Shell
        path=$(readlink -f "$script") # Path

        rm "$HOME/.tmp/scinfo_tmpfile"

        echo -e "Name: $name\nAuthor: $author\nDate: $date\nVersion: $version\nDescription: $description\nShell: $shell\nPath: $path"
    }


    case "$1" in
        -h|--help)
            \cat "$HOME/.startup/help/what"
            ;;
        *)
            setType "$1"
            ;;
    esac
}
