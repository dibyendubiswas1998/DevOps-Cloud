#!/bin/bash



############################################################
# **************** Metadata Information ****************
# Author: Dibyendu
# Date: 20-06-2024
# Purpose: If-Else Block
# ##########################################################


#set -x
#set -e


echo "if-else block"

a=10
b=20

if [ $a > $b ]
then
        echo "a is greater than b"
else
        echo "b is greater than a"
fi