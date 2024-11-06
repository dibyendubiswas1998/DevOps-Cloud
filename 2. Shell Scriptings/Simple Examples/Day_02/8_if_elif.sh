#!/bin/bash





# Build Grade system using if-else:


read -p "Enter your marks: " marks

if [[ $marks -ge 80 ]]
then
        echo "First Deivision !!!"
elif [[ $marks -ge 60 ]]
then
        echo "Second Devision !!!"
elif [[ $marks -ge 40 ]]
then
        echo "Third Devision !!!"
else
        echo "Failed !!!"
fi


