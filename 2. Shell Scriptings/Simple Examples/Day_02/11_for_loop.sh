#!/bin/bash



############ for loop:


# exapmple 1;
echo "example 1:::::::::::::::::::::"

for i in 1 2 3 4 5 6 7 8 9 10
do
        echo "Number: $i"
done


# example 2:
echo
echo "example 2:::::::::::::::::::::"

for j in Raju Ram Hmm Hello Okay
do
        echo "name: $j"
done


# example 3: rage of values
echo
echo "example 3:::::::::::::::::::::"

for p in {1..10}
do
        echo "Number: $p"
done



# example 4: extract content from file:
echo
echo "example 4:::::::::::::::::::::"

FILE_Path="name_file.txt"
for name in $(cat $FILE_Path)
do
        echo "Name is:--------> $name"
done



# example 5: extrcat from array:
echo
echo "example 5:::::::::::::::::::::"

arr=( 1 2 3 4 5 6 7 8 9 10 )
length=${#arr[*]}

for (( i=0; i<$length; i++ ))
do
        echo "val:    ${arr[$i]}"
done



# example 6: infine loop
echo
echo "example 6::::::::::::::::::::"

for (( ; ; ))
do
        echo "Hey Buddy !!"
        sleep 2s
done
