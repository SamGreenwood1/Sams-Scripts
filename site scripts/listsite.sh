#!/bin/bash

# Get the Apache configuration and store it in a variable
apache_output=$(sudo apachectl -S)

# Extract vhost and alias information, then sort the results
(echo "$apache_output" | \
tail -n +10 | \
grep vhost | \
cut -d' ' -f13; \
echo "$apache_output" | \
tail -n +10 | \
grep alias | \
cut -d' ' -f19) | \
sort
