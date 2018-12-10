#!/bin/bash

find /backup/archive/* -mtime 1 -delete

Domains=("vz.usi.ua" "mk.usi.ua" "korona.usi.ua" "usi.ua")
Path="/backup/archive"
Current_date=$(date +%d-%m-%Y)

for domain in ${Domains[*]}
do
 Temp="$Path/$Current_date/temp-${domain}.log"
 Log="$Path/$Current_date/log-${domain}.log"

 Begin_time=$(date +%s)
 mkdir -p "$Path/$Current_date/$domain"

 echo "Backup time for all mailboxes of $domain- $(date +%T)"

 echo "Start of Backup - $(date +%T)" > $Log

 /opt/zimbra/bin/zmprov -l gaa $domain > $Temp
 if [ $? -eq 0 ]
 then
  echo "[OK]"
  echo "The list of mailboxes was successfully executed." >> $Log
 else
  echo "[FAIL]"
  echo "The list of mailboxes could not be created. Shutdown (Failure)." >> $Log
  exit
 fi

 echo "Back up all mailboxes of $domain"
 echo "Creating a $Current_date directory to host a backup." >> $Log
 for mailbox in $( cat $Temp)
 do
  /opt/zimbra/bin/zmmailbox -z -m $mailbox getRestUrl "//?fmt=tgz" > $Path/$Current_date/$domain/$mailbox.tgz
  if [ $? -eq 0 ]
  then
   echo "$mailbox-[OK]"
   echo "Mailbox backup of $mailbox successful" >> $Log
  else
   echo "$mailbox-[FAIL]"
   echo "Mailbox backup of $mailbox is not successful" >> $Log
  fi
 done

 End_time=$(date +%s)
 Elapsed_time=$(expr $End_time - $Begin_time)
 Hours=$(($Elapsed_time / 3600))
 Elapsed_time=$(($Elapsed_time - $Hours * 3600))
 Minutes=$(($Elapsed_time / 60))
 Seconds=$(($Elapsed_time - $Minutes * 60))
 echo "Spent time on backup: $Hours hour $Minutes minutes $Seconds seconds"
 echo "Spent time on backup: $Hours hour $Minutes minutes $Seconds seconds" >> $Log
done

