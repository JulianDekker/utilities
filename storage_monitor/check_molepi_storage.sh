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

du -h --max-depth=1 /exports/archive/molepi-lts/ > logs/molepi_archive_storage_I.log
du -h --max-depth=1 /exports/molepi/ > logs/molepi_research_storage_I.log


current_date_epoch=$(date +%s)

echo "$current_date_epoch" > last_check.txt
sh cronjob.sh


