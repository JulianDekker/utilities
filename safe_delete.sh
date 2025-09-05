#!/bin/bash

# A simple script to safely delete a directory and its contents.
# It first verifies that a copy exists and that all files are present in the copy.
echo "This is a simple script to delete directories that have already been copied to a new location, for the delete to succeed you need to specify the new location of the directory. This script will compare the contents of both directories. Only if the copy location has the same files or more files the delete will succeed. Be carefull, this script only checks for the presence of the files, not the contents. The contents should have already been checked at time of the copy."
echo "--------------"
# Function to display script usage
usage() {
    echo "Usage: $0 -d <directory_to_delete> -c <copy_directory>"
    echo ""
    echo "Options:"
    echo "  -d <directory_to_delete>  The directory you want to delete."
    echo "  -c <copy_directory>       The directory containing a copy of the contents."
    echo ""
    exit 1
}

# Check for correct number of arguments
if [ "$#" -ne 4 ]; then
    usage
fi

# Parse command-line arguments
while getopts ":d:c:" opt; do
    case ${opt} in
        d )
            DELETE_DIR=$OPTARG
            ;;
        c )
            COPY_DIR=$OPTARG
            ;;
        \? )
            echo "Invalid option: -$OPTARG" >&2
            usage
            ;;
        : )
            echo "Invalid option: -$OPTARG requires an argument" >&2
            usage
            ;;
    esac
done

# Check if directories exist and are valid
if [ ! -d "$DELETE_DIR" ]; then
    echo "Error: Directory to delete '$DELETE_DIR' does not exist."
    exit 1
fi

if [ ! -d "$COPY_DIR" ]; then
    echo "Error: Copy directory '$COPY_DIR' does not exist. No deletion will occur."
    exit 1
fi

# Compare contents of the directories
echo "Comparing contents of '$DELETE_DIR' with '$COPY_DIR'..."

# Use process substitution to compare sorted lists of filenames
# Add `--label` options to explicitly name the directories in the output.
# diff --unchanged-line-format="" --old-line-format="Missing from $COPY_DIR: %L" --new-line-format="" --label "$DELETE_DIR" --label "$COPY_DIR" <(find "$DELETE_DIR" -printf '%P\n' | sort) <(find "$COPY_DIR" -printf '%P\n' | sort) > diff_output.txt

# Capture the output of the custom diff command
# missing_output=$(cat diff_output.txt)

# MISSING_FILES=false
#if ! diff -q <(find "$DELETE_DIR" -printf '%P\n' | sort) <(find "$COPY_DIR" -printf '%P\n' | sort) > /dev/null; then
#if [ ! -z "$missing_output" ]; then  
#if ! diff -q <(find "$DELETE_DIR" -printf '%P\n' | sort) <(find "$COPY_DIR" -printf '%P\n' | sort) >/dev/null; then
#    MISSING_FILES=true
#fi

#if $MISSING_FILES; then
if ! diff -q <(find "$DELETE_DIR" -printf '%P\n' | sort) <(find "$COPY_DIR" -printf '%P\n' | sort) >/dev/null; then
echo ""
    echo "WARNING: The following files are missing from the copied directory:"
    # diff -rq "$DELETE_DIR" "$COPY_DIR"
    # diff <(find "$DELETE_DIR" -printf '%P\n' | sort) <(find "$COPY_DIR" -printf '%P\n' | sort)
    #echo "$missing_output"
    diff  --unchanged-line-format="" --old-line-format="Missing from copied directory: %L \n" --new-line-format="" <(find "$DELETE_DIR" -printf '%P\n' | sort) <(find "$COPY_DIR" -printf '%P\n' | sort)
    echo ""
    read -p "Some contents are missing from the copy. Do you still want to delete '$DELETE_DIR'? (y/N) " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Deletion cancelled."
        exit 1
    fi
else
    echo "All contents are present in the copy directory. Proceeding with deletion."
fi

# Prompt for confirmation before deletion
#read -p "Are you sure you want to delete '$DELETE_DIR' and all its contents? (y/N) " -n 1 -r
#echo ""
#if [[ ! $REPLY =~ ^[Yy]$ ]]; then
#    echo "Deletion cancelled."
#    exit 1
#fi

# Perform the deletion
echo "Deleting '$DELETE_DIR'..."
if rm -rf "$DELETE_DIR"; then
    echo "Successfully deleted '$DELETE_DIR'."
else
    echo "Error: Failed to delete '$DELETE_DIR'."
    exit 1
fi

exit 0
