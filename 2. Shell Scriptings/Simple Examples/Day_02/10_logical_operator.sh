#!/bin/bash



############## Logical Operator:


read -p "Enter your age: " age
read -p "Enter your Country: " country


if [[ $age -ge 18 ]] && ([[ $country == "India" ]] || [[ $country == "india" ]])
then
        echo "You can Vote !!!"
else
        echo "You can not Vote !!!"
fi



[[ $age -ge 18 ]] && echo "Adult" || echo "Minior"



