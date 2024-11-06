#!/bin/bash


###################################
# ********** Metadata Information *************

# Author: Dibyendu Biswas.
# Date: 20-06-2024
# Purpose: This script outputs the node health.
# Version: v1
###################################


set -x # debug mode

echo "Print the disk space:"
df -h # check the disk space.


echo "\n\nPrint the Memory:"
free -g


echo "\n\nPrint the number of CPU:"
nproc