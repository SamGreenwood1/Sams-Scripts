#!/bin/sh

if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Expected 2 file arguments, abort!"
    exit 1
fi

if [ ! -z "$3" ]; then
    echo "Expected 2 file arguments but found a 3rd, abort!"
    exit 1
fi

if [ ! -f "$1" ]; then
    echo "File '$1' not found, abort!"
    exit 1
fi

if [ ! -f "$2" ]; then
    echo "File '$2' not found, abort!"
    exit 1
fi

# avoid moving between drives
tmp=$(mktemp --tmpdir="$(dirname '$1')")
if [ $? -ne 0 ]; then
    echo "Failed to create temp file, abort!"
    exit 1
fi

# Exit on error,
mv "$1" "$tmp"
if [ $? -ne 0 ]; then
    echo "Failed to to first file '$1', abort!"
    rm "$tmp"
    exit 1
fi

mv "$2" "$1"
if [ $? -ne 0 ]; then
    echo "Failed to move first file '$2', abort!"
    # restore state
    mv "$tmp" "$1"
    if [ $? -ne 0 ]; then
        echo "Failed to move file: (unable to restore) '$1' has been left at '$tmp'!"
    fi
    exit 1
fi

mv "$tmp" "$2"
if [ $? -ne 0 ]; then
    # this is very unlikely!
    echo "Failed to move file: (unable to restore) '$1' has been left at '$tmp', '$2' as '$1'!"
    exit 1
fi
