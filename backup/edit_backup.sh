#!/bin/bash

destination_dir="/exports/archive/molepi-lts/backups"
source_dir=$1
end_date=$2

if [ -z "$source_dir" ] || [ ! -d "$destination_dir" ]; then
    echo "source or backup directory does not exist!"
    exit 1
fi

CURRENT_DIR=$(pwd)


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


if crontab -l | grep -q "$source_dir "; then
    echo "Removing cron job."
    crontab -l | grep -v "/home/jjdekker1/utilities/backup/cronjob.sh $source_dir " | crontab -

    echo "Re-adding cron-job".
    (crontab -l 2>/dev/null; echo "0 1 * * * /home/jjdekker1/utilities/backup/cronjob.sh $source_dir $destination_dir $end_date_epoch $CURRENT_DIR") | crontab -
    echo "$(date)" $source_dir backup edited -- user requested to change backup settings. >> $destination_dir/auto_backup_log.txt
else
    echo "Directory '$source_dir' does not exist in crontab. Either the backup is already removed or the wrong input was entered, you can check your active jobs using command 'crontab -l'."
    # Add code to handle the case where the string does not exist
fi

