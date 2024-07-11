# Shark automated backups
These scripts are meant to help researchers set up temporary automated backups for data temporarily stored on the research drive. Because the data must be permanently and properly archived after finishing the project these scripts do not support any permanent backup solutions. 

AFTER THE END DATE EXPIRES THE BACKUP WILL BE DELETED FROM THE LTS.

## Backup storage location
Backups will be stored at `/exports/archive/molepi-lts/backups/`. To save LTS space the backup will be compressed into a tar.gz.

## backup frequency
Backups are updated every day at 01:00. 

## creating a backup using `make_backup.sh`
The make_backup.sh script supports two arguments: the 'folder path' to backup and the end_date for the backup script in the format (YYYY-MM-DD).

### example usage:
```sh make_backup.sh /exports/molepi/MOLEPI_PROJECTS/ExampleProject_JulianDekker_220901_Aging/ 2024-07-12```
This example command will create a backup of the ExampleProject_JulianDekker_220901_Aging project directory, the backup will be updated daily at 01:00 until 12 Juli 2024. 

## Editing an existing backup using `edit_backup.sh`
the edit_backup.sh is used to edit the duration of a running backup. The script supports two arguments, the directory path to edit the backup from (this has to be the same as previously entered, if unsure check the path using the command `crontab -l`) and the new end date. 

### example usage:
```sh edit_backup.sh /exports/molepi/MOLEPI_PROJECTS/ExampleProject_JulianDekker_220901_Aging/ 2024-07-15```
This example command edits the running backup of the ExampleProject_JulianDekker_220901_Aging project directory, the ending date for the backup is changed to 15 Juli 2024.

## Removing the automated backup using `remove_backup.sh`.
The remove_backup.sh script was made to stop an active backup. Running this script will stop any further backups from being made and DELETE the backup directory from the long-term storage. Before running this make sure your data is available in the original location. 

The script has one argument, the path to the directory to stop backing up. After running the command you will be asked to confirm you want to delete the backup by inputting the word "CONTINUE" in all caps.

### Example usage:
```sh remove_backup.sh /exports/molepi/MOLEPI_PROJECTS/ExampleProject_JulianDekker_220901_Aging/```
Are you sure you want to REMOVE the backup? This will also delete the backup stored at /exports/archive/molepi-lts/backups. Type 'CONTINUE' to continue.. `CONTINUE`

## Restoring data from backup
To restore data from the backup you need to extract the .tar.gz. for this you can use the `tar -xzf [directory]` command. Below is an example script for restoring the backup to the same location it was created from. 

### example command for restoring from backup:
```mkdir -p /exports/molepi/MOLEPI_PROJECTS/ExampleProject_JulianDekker_220901_Aging/ \&\& tar -xzf /exports/archive/molepi-lts/backups/ExampleProject_JulianDekker_220901_Aging.tar.gz -C /exports/molepi/MOLEPI_PROJECTS/ExampleProject_JulianDekker_220901_Aging/ --strip-components=1 ```

## checking the currently active backups
You can check the backups by using the command: `crontab -l`. This will result in a list of currently active backup jobs. The resulting information will be something like this:
```0 1 * * * /exports/molepi/MOLEPI_PROJECTS/Tools/Backup//cronjob.sh /exports/molepi/MOLEPI_PROJECTS/ExampleProject_JulianDekker_220901_Aging/ /exports/archive/molepi-lts/backups/ 1720735200 /exports/molepi/MOLEPI_PROJECTS/Tools/Backup```
```
0 1 * * * indicates the backup runs one time per day at 01:00.
/exports/molepi/MOLEPI_PROJECTS/Tools/Backup//cronjob.sh is the location of the backup script, this is not important for general use. 
/exports/molepi/MOLEPI_PROJECTS/ExampleProject_JulianDekker_220901_Aging/ is the directory that is being backed up. Use this string to edit or remove the backup. 
/exports/archive/molepi-lts/backups/ is the location where the backups are stored. 
1720735200 is the end date for the script written as an epoch string. You can use this website to convert it back to normal dates: https://www.epochconverter.com/. 
/exports/molepi/MOLEPI_PROJECTS/Tools/Backup is the current working directory, this is only important when you are not using an absolute path (starting with /exports/). In that case, you need to keep in mind all actions by the script are performed using this directory as reference. 
```
