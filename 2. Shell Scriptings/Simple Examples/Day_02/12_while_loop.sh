#!/bin/bash



#########3 While Loop:


# example 1:
echo "example 1::::::::::::"
count=0
num=10

while [[ $count -le $num ]]
do
        echo "num: $count"
        let count++
done




# example 2: Infine loop
echo
echo "example 2:::::::::::"

while true
do
        echo "Hi Buddy"
        sleep 2s
done


