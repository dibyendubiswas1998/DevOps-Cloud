#!/bin/bash



# Arrays:


myArray=( 1 2 3.5 Hello "Hello Wrold" )

# get the value index wise:

echo "index 0: ${myArray[0]}"
echo "index 3: ${myArray[3]}"



# Get all the values
echo "All the values in array: ${myArray[*]}"


# Length of the array:
echo "Length of array: ${#myArray[*]}"


# How to get specific vlues:
echo "specific values: ${myArray[*]:1}"
echo "values from index 2-3: ${myArray[*]:2:2}"

# Update the array with new values:
myArray+=( 20 40 50 )

echo "New Array: ${myArray[*]}"


