#!/bin/bash


# break

echo "use of break statement:"
read -p "enter the number: " n

for i in {1..10}
do
        if [[ $n -eq $i ]]
        then
                echo "$n is found !!!"
                break
        fi
        echo "Numbers: $i"
done


