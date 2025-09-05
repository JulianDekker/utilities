#!/bin/bash

# This script first copies all files from a source directory to a destination
# directory and then compares the md5sum of all corresponding files.
# It works recursively, so it will check files in subdirectories as well.

# --- Usage and Input Validation ---
# Check if exactly two arguments were provided.
if [ "$#" -ne 2 ]; then    
	echo "Usage: $0 <original_directory> <copied_directory>"        
	exit 1	
fi

# Assign command-line arguments to descriptive variables.
ORIG_DIR="$1"	
COPY_DIR="$2"

# Check if the provided directories exist and are directories.
if [ ! -d "$ORIG_DIR" ]; then
	echo "Error: One or both directories do not exist."	  
  	exit 1
fi

# --- File Copy Logic ---
echo "Starting the recursive copy of files from '$ORIG_DIR' to '$COPY_DIR'..."
echo "--------------------------------------------------------"

# Use 'cp -r' to recursively copy all files and subdirectories.
# The `.` at the end of the source path ensures the contents are copied,
# not the directory itself.
cp -r "$ORIG_DIR/." "$COPY_DIR"


# Check if the copy was successful
if [ $? -ne 0 ]; then
	echo "Error: The file copy failed. Exiting script."
	exit 1
fi
echo "Copy complete."
echo "--------------------------------------------------------"

# --- Main Comparison Logic ---
echo "Starting MD5 checksum comparison..."
echo "--------------------------------------------------------"

# Use 'find' to get a list of all regular files (-type f) in the original directory.
# The 'while read -r' loop processes each file path one by one.
find "$ORIG_DIR" -type f | while read -r orig_file; do
# Get the relative path of the file from the original directory.
# This is done by removing the original directory path from the full file path.
relative_path="${orig_file#$ORIG_DIR/}"

# Construct the full path to the corresponding file in the copied directory.
copy_file="$COPY_DIR/$relative_path"

# Check if the corresponding file exists in the copied directory.
if [ ! -f "$copy_file" ]; then
	echo "MISSING: $relative_path (File does not exist in the copied directory)"
	continue # Skip to the next file if it's missing.
fi

# Calculate the MD5 checksum of the original file.
# 'md5sum' outputs the checksum and filename. 'awk' extracts only the checksum.
orig_md5=$(md5sum "$orig_file" | awk '{print $1}')

# Calculate the MD5 checksum of the copied file.
copy_md5=$(md5sum "$copy_file" | awk '{print $1}')

# Compare the two checksums.
if [ "$orig_md5" == "$copy_md5" ]; then
	#echo "MATCH: $relative_path"
	continue # no need to display every match
else
	echo "MISMATCH: $relative_path"
fi																	    
done

echo "--------------------------------------------------------"
echo "Comparison complete. Copy mismatches will be displayed above (if any)."

