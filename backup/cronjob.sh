#!/bin/bash

# If the script is run with parameters
if [ "$#" -eq 4 ]; then
    source_dir=$1
    destination_dir=$2
    end_date_epoch=$3
    script_dir=$4
    current_date_epoch=$(date +%s)
    cd $script_dir
    if [ $current_date_epoch -ge $end_date_epoch ]; then
        echo "End date reached. Removing cron job."
        crontab -l | grep -v "/home/jjdekker1/utilities/backup/cronjob.sh $source_dir " | crontab -
	echo "Removing backup folder".]
	rm "$destination_dir"/$(basename "$source_dir").tar.gz
	echo "$(date)" $source_dir backup removed -- backup date expired. >> $destination_dir/auto_backup_log.txt
        exit 0
    fi
    if [ ! -d "$source_dir" ]; then
	echo "$source_dir does not exist!"
        echo "$(date)" $source_dir backup failed!! -- source directory does not exist! If it did exist before please restore from backup using command: \"mkdir -p $source_dir \&\& tar -xzf $destination_dir/$(basename "$source_dir").tar.gz -C $source_dir --strip-components=1 \". The backup will stay available and retry creating a new backup every day at 01:00 until "$(date -d @$end_date_epoch)".  >> $destination_dir/auto_backup_log.txt
    else
    	# Perform the backup
    	tar -czf "$destination_dir"/$(basename "$source_dir").tar.gz "$source_dir"
    
    	echo "Backup of $source_dir to $destination_dir completed at $(date)"
    	echo "$(date)" $source_dir backup completed. >> $destination_dir/auto_backup_log.txt
    fi
fi
