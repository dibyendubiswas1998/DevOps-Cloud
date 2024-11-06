#!/bin/bash



####################################################
# ************** Metadata Information **************
# Author: Dibyendu Biswas.
# Date: 20-06-2024
# Purpose: Find out the some specific process.
####################################################



set -x # debug mode
set -e # exits the scripts when there is an error occurs at any line.
set -o pipefail # exits if any error occurs in pipe




echo "Print all the running process related to amazon"
ps -ef | grep "amazon"
echo "---------------------------------------------------"


echo "Print the 'id' of the running process related to amazon"
ps -ef | grep "amazon" | awk -F" " '{print $2}'
echo "---------------------------------------------------"


echo "Print the 'process name' and 'id' of the running process related to amazon"
ps -ef | grep "amazon" | awk -F" " '{print $1 " " $2}'