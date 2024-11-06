#!/bin/bash




# Store Key-value pair;

declare -A arr
arr=( [name]=Dibyendu [age]=26 )
echo "arr: ${arr[*]}"
echo "Name: ${arr[name]}"


