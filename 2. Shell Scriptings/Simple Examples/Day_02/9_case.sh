#!/bin/bash




## Case:


echo "Provide an Oprtions:::::"
echo "a = for print the date"
echo "b = for print the list of files"
echo "c = for checking the current directory path"


read -p "Select any Optins: " choice

case $choice in
        a)
                echo "Today date is: $date"
                echo "Ending..........."
                ;;
        b)ls;;
        c)pwd;;
        *)echo "Please provide valid input !!!"
esac



