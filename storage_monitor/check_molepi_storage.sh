#!/bin/bash

#SBATCH --job-name=spacecheck_molepi           # Job name
#SBATCH --output=space_molepi.out              # Output file name
#SBATCH --error=space_molepi.err               # Error file name
#SBATCH --partition=all               # Partition
#SBATCH --time=96:00:00                 # Time limit
#SBATCH --nodes=1                       # Number of nodes
#SBATCH --ntasks-per-node=1             # MPI processes per node
#SBATCH --mem=16G

cd $1

du -h --max-depth=2 /exports/archive/molepi-lts/| awk 'NF==2' | sort -hr > logs/molepi_archive_storage_depth2.log
sh git_push.sh molepi_archive_storage_depth2.log
du -h --max-depth=1 /exports/molepi/ | sort -hr > logs/molepi_research_storage_depth1.log
sh git_push.sh molepi_research_storage_depth1.log


current_date_epoch=$(date +%s)

echo "$current_date_epoch" > last_check.txt
sh cronjob.sh
#sh git_push.sh

