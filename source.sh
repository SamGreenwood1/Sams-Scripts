#!/bin/bash

file=".bashrc"
. "$file"

if [ "$?" -eq "0" ]; then
  echo "Successfully sourced .bashrc"
else
  dos2unix "$file"
  . "$file"
fi
