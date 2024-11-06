#!/bin/bash



# If user does not provide any argument then simply exits:
if [[ $# -eq 0 ]]
then
        echo "no arguments provided during runtime"
        exit 1
fi




# Pass the arguments during execution:

echo "First Argument: $1"
echo "Second Argument: $2"

echo "My name is $1 and age is $2"
echo


echo "All the arguments are - $@"
echo "Number of arguments are - $#"

echo



# use for loop and execute one by one:

for file in $@
do
        echo "File names are: $file"
done
