#!/bin/bash

# If the script is run with parameters
input_epoch=$(cat last_check.txt)
echo $input_epoch
current_date_epoch=$(date +%s)
four_weeks_ago=$((current_date_epoch - 4 * 7 * 24 * 3600))
run_dir='/home/jjdekker1/utilities/storage_monitor/'

cd $run_dir

if (( $input_epoch <= $four_weeks_ago )); then	
    echo "Updating directory list"
    sbatch check_molepi_storage.sh $run_dir
    sbatch check_molepi_common.sh $run_dir
    exit 1
    #sbatch check_archive.sh
    #sbatch check_users.sh
    #echo "$current_date_epoch" > last_check.txt   
fi


USAGE_RESEARCH=$(df -h /exports/molepi | awk 'NR==2 {print $5}' | sed 's/%//')
USAGE_ARCHIVE=$(df -h /exports/archive/molepi-lts | awk 'NR==2 {print $5}' | sed 's/%//')

if [ "$USAGE_RESEARCH" -gt 90 ]; then
  echo "Warning: Disk usage for the research storage is above 90% ($USAGE_RESEARCH%)"
  df -h /exports/molepi > logs/molepi_research_storage.log
  echo -e "\n\n" >> logs/molepi_research_storage.log
  # Send a custom email at the end of the job
  {
    echo "Subject: Warning: Disk usage for the research storage is above 90% ($USAGE_RESEARCH%)"
    echo "To: j.j.dekker1@lumc.nl"
    echo
    cat logs/molepi_research_storage.log
    cat logs/molepi_research_storage_I.log
  } | /usr/sbin/sendmail -t
fi


if [ "$USAGE_ARCHIVE" -gt 90 ]; then
  echo "Warning: Disk usage for the archive storage is above 90% ($USAGE_ARCHIVE%)"
  df -h /exports/archive/molepi-lts > molepi_archive_storage.log
  echo -e "\n\n" >> logs/molepi_archive_storage.log
  # Send a custom email at the end of the job
  {
    echo "Subject: Warning: Disk usage for the archive storage is above 90% ($USAGE_ARCHIVE%)"
    echo "To: j.j.dekker1@lumc.nl"
    echo
    cat logs/molepi_archive_storage.log
    cat logs/molepi_archive_storage_I.log
  } | /usr/sbin/sendmail -t
fi

