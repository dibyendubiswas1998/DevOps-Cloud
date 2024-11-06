#!/bin/bash



#############################################################
# ************ Metadata Information ****************
# Author: Dibyendu Biswas.
# Date: 20-06-2024
# Purpose: Find out the errors from log file.
# ###########################################################



set -x
set -e
set -o pipefail


echo "Find out Error message from logs file"
curl https://raw.githubusercontent.com/dibyendubiswas1998/NewsShort/main/logs/trainings_logs.txt | grep "Error"


echo "Find out Specific Message, i.e. 'Step 3' related"
curl https://raw.githubusercontent.com/dibyendubiswas1998/NewsShort/main/logs/trainings_logs.txt | grep "Step 3"


echo "Find out Date & Time only from this specific message, i.e. 'Step 3'"
curl https://raw.githubusercontent.com/dibyendubiswas1998/NewsShort/main/logs/trainings_logs.txt | grep "Step 3" | awk -F" " '{print $1 "----" $2}'

