#!/bin/bash

# Get user inputs
#read -p "Enter the directory to copy (full path): " source_dir
#read -p "Enter the location to copy to: " destination_dir
#read -p "Enter the end date for the copy job (YYYY-MM-DD): " end_date

source_dir=$1
end_date=$2

CURRENT_DIR=$(pwd)
destination_dir="/exports/archive/molepi-lts/backups/"
cronjob_dir="/home/jjdekker1/utilities/backup"


# Check if the end date is in the correct format
if ! date -d "$end_date" &> /dev/null; then
    echo "Invalid date format. Please enter the date in YYYY-MM-DD format."
    exit 1
fi

# Convert end date to seconds since epoch
end_date_epoch=$(date -d "$end_date" +%s)
current_date_epoch=$(date +%s)

# Compare current date with end date
if [ $current_date_epoch -ge $end_date_epoch ]; then
    echo "End date must be in the future."
    exit 1
fi

if [ ! -d "$source_dir" ] || [ ! -d "$destination_dir" ]; then
    echo "source or destination directory does not exist!"
    exit 1
fi

# Schedule the cron job to run daily at 01:00am
(crontab -l 2>/dev/null; echo "0 1 * * * /home/jjdekker1/utilities/backup/cronjob.sh $source_dir $destination_dir $end_date_epoch $CURRENT_DIR") | crontab -

echo "Backup job scheduled to run daily at 01:00am until $end_date"

echo "Performing first backup now..."
sh "$cronjob_dir/cronjob.sh" "$source_dir" "$destination_dir" "$end_date_epoch" "$CURRENT_DIR" && echo "$(date)" "$source_dir backup added & first backup completed."
