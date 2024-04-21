#!/bin/bash

read -p "Enter term to replace: " rep
read -p "Enter replacement term: " term
read -p "Enter filename: " file

sudo sed -i "s/$rep/$term/" "$file"
