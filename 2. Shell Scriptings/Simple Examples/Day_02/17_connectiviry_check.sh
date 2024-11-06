#!/bin/bash



read -p "ehich site you want to check: " site

ping -c 1 $site
sleep 5s


echo
if [[ $? -eq 0 ]]
then
        echo "Successfully connected to $site"
else
        echo "Not able to connect $site"
fi
