#!/bin/bash



############## Project 1: Monitoring Free RAM Space:


total_memory=$(free -mt | grep "Total" | awk -F" " '{print $2}')
used_memory=$(free -mt | grep "Total" | awk -F" " '{print $3}')
free_memory=$(free -mt | grep "Total" | awk -F" " '{print $4}')


echo "Total RAM: $total_memory MB"
echo "Used RAM: $used_memory MB"
echo "Available RAM: $free_memory MB"
echo


# If ram sapce less than theshold then print the warining.
TH=500

if [[ $free_memory -lt 500 ]]
then
        echo "WARNING, RAM is running low !!!"
else
        echo "RAM Space is sufficient !!!"
fi
