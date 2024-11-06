#!/bin/bash




############ until Loop


read -p "Enter number: " a

until [[ $a == 1 ]]
do
        echo "val is: $a"
        let a--
done
