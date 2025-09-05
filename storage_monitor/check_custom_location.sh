#!/bin/bash

#SBATCH --job-name=spacecheck_custom           # Job name
#SBATCH --output=space_custom.out              # Output file name
#SBATCH --error=space_custom.err               # Error file name
#SBATCH --partition=all               # Partition
#SBATCH --time=96:00:00                 # Time limit
#SBATCH --nodes=1                       # Number of nodes
#SBATCH --ntasks-per-node=1             # MPI processes per node
#SBATCH --mem=16G

current_date_epoch=$(date +%s)

du -h --max-depth=$2 $1 > logs/custom_storage_$(basename $1)_"$current_data_epoch".log

#echo "$current_date_epoch" > last_check.txt
#sh cronjob.sh


