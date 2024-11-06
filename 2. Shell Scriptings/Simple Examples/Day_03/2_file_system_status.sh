#!/bin/bbash




####### Monitoring Free Disk Space & Send Email Alerts:



total_file_system_memory=$(df -h | grep "root" | awk -F" " '{print $2}')
used_file_system_memory=$(df -h | grep "root" | awk -F" " '{print $3}')
available_file_system_memory=$(df -h | grep "root" | awk -F" " '{print $4}')


echo "Total Space in File System: $total_file_system_memory"
echo "Used Space in File System:  $used_file_system_memory"
echo "Available Space in File System $available_file_system_memory"
echo



# Check if memory greater than 75% then send warnings:
available_file_system_memory_percentage=$(df -h | grep "root" | awk -F" " '{print $5}' | tr -d %)

if [[ $available_file_system_memory_percentage -ge 75 ]]
then
        echo "File System's memory is grater than 75% !!!"
else
        echo "Enough Space ($available_file_system_memory_percentage%) !!!"
fi
echo


# Send Email Notification:

TO="dibyendubiswas1998@gmail.com"

if [[ $available_file_system_memory_percentage -ge 75 ]]
then
        echo "File System's memory is grater than 75% !!!" | mail -s "Disk Space Alert !!!" $TO
else
        echo "Enough Space ($available_file_system_memory_percentage%) !!!"  | mail -s "Disk Space Alert (enogh space) !!!" $TO
fi

