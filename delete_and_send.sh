#!/bin/bash
Current_date=$(date +%d-%m-%Y)
mount -t cifs //192.168.1.9/D$/Backup/Zimbra /mnt/backup -o user=bc-user,password=PASSWORD,domain=usi.ua
find /mnt/backup/* -mtime 4 -delete
cp -R /backup/archive/$Current_date /mnt/backup/
umount /mnt/backup


