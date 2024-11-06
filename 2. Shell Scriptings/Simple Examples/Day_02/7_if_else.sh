#!/bin/bash




# If-Else:


a=70
read -p "Enter your marks: " marks

if [[ $marks -gt $a ]]
then
        echo "You Pass The exam"
else
        echo "You Failed!!!!!!!!"
fi

