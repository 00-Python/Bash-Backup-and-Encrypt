#!/bin/bash

# Define the date format for the filename
datetime=$(date +"%Y-%m-%d_%H:%M:%S")

# Define the source directory and the backup directory
src_dir="/var/www/html" # this is the directory that we will back up
backup_dir="/root/Backup" # This is where we will temporarily store the encrypted backup data

# Create a tarball of the source directory
tar -czf $backup_dir/backup_$datetime.tar.gz $src_dir

# Read the password from a secure file
password=$(cat /root/Backup/pwd)

# Encrypt the tarball using openssl
gpg --pinentry-mode=loopback --passphrase $password --symmetric --cipher-algo AES256 --output $backup_dir/backup_$datetime.tar.gz.gpg $backup_dir/backup_$datetime.tar.gz

rm $backup_dir/backup_$datetime.tar.gz

# Get the .gpg filename 
filename=$(find /home/zero/Backup -type f -name "*.gpg" -print -quit)

# Check if a file was found
if [ -n "$filename" ]; then
	# if file is found send it over ssh to the remote server
	chmod +x $filename
	scp $filename root@<IP-ADDRESS>:/root/Backup
	if [ $? -eq 0 ]; then
		echo "$(date): Backup Successful" >> /home/zero/Backup/backup.log
		# remove file once it has been sent to remote server
		rm -f $filename
	else
		echo "$(date): Error occurred while sending backup to remote server" >> /home/zero/Backup/backup.log
	fi
else
	# if file is not found display error msg 
    echo "$(date): No encrypted file found" >> /home/zero/Backup/backup.log
fi

