#!/bin/bash




# bash variable


echo "random variable $RANDOM"
echo "User Id of the user logged in: $UID"
echo


# generating a random number bentween 1 to 6

no=$(( $RANDOM%6 + 1))
echo "generating a random number bentween 1 to 6: $no"
echo


# check user is root or not:

if [[ $UID -eq 0 ]]
then
        echo "User is root"
else
        echo "user is not root : $UID"
fi

