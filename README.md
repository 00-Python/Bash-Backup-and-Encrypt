# Backup and Encryption Script for Linux Servers

This repository contains a bash script for backing up, encrypting, and transferring data to a remote server. The script is designed to work with Linux servers and uses tar, gpg, and scp for creating backups, encryption, and secure file transfer respectively.

## Setup

1. **SSH Key Setup:** The script requires SSH keys to be set up between the root user of the main server and the backup server. This is to avoid storing passwords in the scripts. Follow these steps to set up the SSH keys:

    - Generate the key pair on the main server with the following command: `ssh-keygen -t rsa`
    - Copy the public key to the remote server using the `ssh-copy-id` command.

2. **Script Permissions:** After writing the bash script for the backup, encryption, and transfer to the remote server, change the script's permissions with `chmod 700 <filename>` so that only the root user can view and run it.

3. **Password File:** The script requires a secure password file. To create this file, make a file in the `/home/zero/Backup` directory called `pwd` and change the file permissions so that only the owner (in this case, root) user can read it. This can be done with `chmod 600 pwd`.

4. **Cron Job:** To automate the backup process, create a cron job that runs the backup script at 3AM every Sunday from the root account. Use `crontab -e` and append this line to the end of the file: `0 3 * * 0 /home/zero/Backup/backup_script.sh`.

## Decryption

To decrypt the file on the remote server, use the following command: `gpg -d backup_xxxxxxxx.tar.gz.gpg > decrypted.tar.gz`. It will then ask for the password and decrypt the file.

## Note

Please replace `<IP-ADDRESS>` in the script with the actual IP address of your remote server.
