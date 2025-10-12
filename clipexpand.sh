#!/bin/bash

# ClipExpand - Clipboard-based Text Expansion Tool
# Version: 3.0 (Remote Desktop Compatible)
# Optimized for Remote Desktop - copies text to clipboard for pasting

# If ~/.clipexpand directory does not exist, create it
if [ ! -d ${HOME}/.clipexpand ]; then
    mkdir ${HOME}/.clipexpand
fi

# Store base directory path, expand complete path using HOME environment variable
base_dir=$(realpath "${HOME}/.clipexpand")

# Set globstar shell option (turn on) ** for filename matching glob patterns on subdirectories of ~/.clipexpand
shopt -s globstar

# Find regular files in base_dir, pipe output to sed
abbrvs=$(find "${base_dir}" -type f | sort | sed "s?^${base_dir}/??g")

# 'Echo'ing the options instead of passing them directly
# to zenity allows names like '+1' or '-1'
name=$(echo ${abbrvs} | tr ' ' '\n' | zenity --list --title=ClipExpand --width=275 --height=400 --column=Snippets)

path="${base_dir}/${name}"

if [ -f "${base_dir}/${name}" ]
then
  if [ -e "$path" ]
  then
    # Put text in primary buffer for Shift+Insert pasting
    echo -n "$(cat "$path")" | xsel -p -i

    # Put text in clipboard selection for apps like Firefox that
    # insist on using the clipboard for all pasting
    echo -n "$(cat "$path")" | xsel -b -i

    # Show system notification
    notify-send -t 1000 "ClipExpand" "Text copied to clipboard!"

  else
    zenity --error --text="Snippet not found:\n${name}"
  fi
fi
