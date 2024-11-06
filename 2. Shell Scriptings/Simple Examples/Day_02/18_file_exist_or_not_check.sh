#!/bin/bash



############3 Check file exists or not:


# example 01:
echo "example 01:::::::::::::"
file_path="name_file.txt"

if [[ -f $file_path ]]
then
        echo "file is exists"
        cat $file_path
else
        echo "file is not exists !!!"
        exit 1
fi





# example 02:
echo
echo "example 02:::::::::::::"

read -p "Enter file path: " file
if [[ ! -f $file ]] # if file is not present
then
        touch $file
        echo "$file is successfully created !!!"
else
        echo "content of file $file"
        cat $file
fi
