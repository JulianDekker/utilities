#!/bin/bash

destination_dir="/exports/archive/molepi-lts/backups"
source_dir=$1

if [ -z "$source_dir" ] || [ ! -d "$destination_dir" ]; then
    echo "source or backup directory does not exist!"
    exit 1
fi

read -p "Are you sure you want to REMOVE the backup? This will also delete the backup stored at $destination_dir. Type 'CONTINUE' to continue.. " answer

if [ -z "$answer" ] || [ "$answer" != "CONTINUE" ]; then
    echo "Remove canceled, user did not answer 'CONTINUE'"
    exit 0
fi    

if crontab -l | grep -q "$source_dir "; then
    echo "Removing cron job."
    crontab -l | grep -v "/home/jjdekker1/utilities/backup/cronjob.sh $source_dir " | crontab -
    echo "Removing backup folder".]
    rm "$destination_dir"/$(basename "$source_dir").tar.gz
    echo "$(date)" $source_dir backup removed -- user requested to remove directory. >> $destination_dir/auto_backup_log.txt
else
    echo "Directory '$source_dir' does not exist in crontab. Either the backup is already removed or the wrong input was entered, you can check your active jobs using command 'crontab -l'."
    # Add code to handle the case where the string does not exist
fi

