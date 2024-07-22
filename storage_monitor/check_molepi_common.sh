#!/bin/bash

#SBATCH --job-name=spacecheck_molepi_work           # Job name
#SBATCH --output=space_molepi_work.out              # Output file name
#SBATCH --error=space_molepi_work.err               # Error file name
#SBATCH --partition=all               # Partition
#SBATCH --time=96:00:00                 # Time limit
#SBATCH --nodes=1                       # Number of nodes
#SBATCH --ntasks-per-node=1             # MPI processes per node
#SBATCH --mem=16G

cd $1

du -h --max-depth=1 /exports/molepi/MOLEPI_PROJECTS/ > logs/molepi_research_projects.log
du -h --max-depth=1 /exports/molepi/users/ > logs/molepi_research_users.log





