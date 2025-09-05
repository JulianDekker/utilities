#!/bin/bash

# Check if argument is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <new_folder_name>"
    exit 1
fi

# Check if folder to copy exists
if [ ! -d "/exports/molepi/MOLEPI_PROJECTS/ExampleProject_JulianDekker_220901_Aging/" ]; then
    echo "Error: 'original_folder' does not exist"
    exit 1
fi

# Set new folder name
new_folder="$1"
pathvar="/exports/molepi/MOLEPI_GUESTS/"

# Copy folder and rename
cp -r "/exports/molepi/MOLEPI_PROJECTS/ExampleProject_JulianDekker_220901_Aging/" "$pathvar/$new_folder"

# Set permissions to a different group
chgrp -R "5-A-SHARK-molmed-guests" "$pathvar/$new_folder"
chmod -R g+rwX "$pathvar/$new_folder"

# Change directory
cd "$pathvar/$new_folder" || exit

# Success message
echo "Folder copied and permissions set. Changed directory to '$pathvar/$new_folder'."
