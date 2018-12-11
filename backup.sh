#!/bin/bash
##################################################################################################################
### Synopsis: Create a compressed archive and copy it to a network share
##################################################################################################################

#################### Steps ####################
# 1. Get todays date in format yyyymmdd
# 2. Make a folder in tmp to store the backup if it's already made it will log and exit
# 3. Use tar to create a .bz2 compressed archive and store it in the temp directory
# 4. Use SCP to copy file to network share
# 5. Log to system the time it took to do it. This should also help in looking for problems

#################### SOME NOTES ####################
# Only run this in a time when no one is online to prevent slowdown
# Store in /usr/local/sbin/ for root crontab

#### IMPORTANT ####
# Since we are running the command as root we want to set correct permissions on the file
# Also make sure to set the private key to secure permissions so we don't have someone reading it who isn't supposed to.


# Type the following at the end of the crontab file using the "sudo crontab -e" command without the # sign
# 0 3 * * 1-5  /usr/local/sbin/backup.sh
# This means every Monday-Friday run the script backup.sh
# Some other popular options are
# 0 3 * * * /usr/local/sbin/backup.sh <------- Run the script every day at 3 am
# 0 3 * * 6-7 /usr/local/sbin/backup.sh <-------- Run the script ever saturday and sunday at 3 am
# 0 0 1 * * /usr/local/sbin/backup.sh <------------ Run the script on the first of the month at midnight, this is discouraged unless you only need monthly backups


##################################################################################################################
start="$(/bin/date +%s)"
todaysDate="$(/bin/date +%Y%m%d)"

/bin/mkdir /tmp/backup_$todaysDate

if [ "$?" = "0" ]; then
	logger Staring the backup
else
	logger "ERROR_Backup: Already did the backup for the day"
	exit 1
fi
# If Compute resource is a concern use the -z (gzip) instead of -j (bzip) and replace the extention with .gz
# For extraction you will replace the c(create) with a x(extract)  and remove -S
# Because we change permissions (see Below) you may have to change them back for extraction

/usr/tar -pcjSf /tmp/backup_$todaysDate/backup_$todaysDate.tar.bz2 /sharing/userhomes/

# We do this so no one can list the files and find any hidden treasures <--- Looking at tar -t option

/bin/chmod 700 /tmp/backup_$todaysDate/backup_$todaysDate.tar.bz2



# Because this is a bigger file it may take some time to do depending on network traffic
/usr/bin/scp -i /id_rsa  /tmp/backup_$todaysDate/backup_$todaysDate.tar.bz2 Copyuser@192.168.1.202:/volume1/Backups

/usr/bin/logger -i Backup_Finished in: $((($(date +%s)-$start)/60)) minutes
