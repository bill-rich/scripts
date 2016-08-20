#!/usr/bin/env bash

#
# Syntax       : rename-file.sh FULL_PATH_TO_FILE
# Author       : Cristian Vasile Mocanu
# Version      : 2016-07-01_11-15
#
# Dependencies : sudo apt-get install -y zenity xdotool
#
# Copyright : public domain
#
# Improvements are welcome :)
#

#
# Purpose:
# --------
# Thunar crashes pretty often when renaming files.
# This script is meant to replace it's single-file rename functionality. Multi-rename is not implemented.
#
# Setup:
# ------
# (1) Create a new Thunar custom action (Edit -> Configure custom actions -> +) with the following settings:
# - on the Basic tab
#     - Name    : Rename file...
#     - Command : /full/path/to/rename-file.sh %f
# - on the Appearance Conditions tab
#     - File Pattern                  : *
#     - Appears if selection contains : check all checkboxes
#
# (2) Use this script for F2 (to replace Thunar's)
# - Settings -> Appearance -> Settings tab -> Enable editable accelerators
# - Thunar -> File -> hover the mouse cursor over "Rename file..." and press F2
#

full_file_to_rename=$1
if [ ! -f $full_file_to_rename && ! -d $full_file_to_rename ]; then
    zenity --error --text="$full_file_to_rename does not exist."
    exit 1
fi

directory="${full_file_to_rename%/*}"
filename="${full_file_to_rename##*/}"
new_file_name=$(zenity --entry "--entry-text=$filename" --text="Enter the new name" --title="Rename $full_file_to_rename")
[ $? -eq 0 ] || exit $?; # exit for none-zero return code
if [ -z "$new_file_name" ]; then
    # do nothing if new filename is empty
    exit $1
fi

new_full_filename="$directory/$new_file_name"
rename_output=$(mv "$full_file_to_rename" "$new_full_filename" 2>&1)
[ $? -eq 0 ] || zenity --error --text="Failed to rename '$full_file_to_rename' to '$new_full_filename':\n$rename_output"

# select new file in Thunar
window_id=`xdotool search --sync --onlyvisible --class 'Thunar' | head -n1`
#xdotool key --clearmodifiers 'ctrl+s'
xdotool type "$new_file_name"
xdotool key "Escape"
