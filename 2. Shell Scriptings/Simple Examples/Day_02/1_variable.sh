#!/bin/bash



# How to use variables:

a=10
b=20
name="Dibyendu"
age=26


echo "a value is: $a"
echo "b value is: $b"
echo "My name is $name and age is $age"

name="Arko"
echo "name: $name"



##############################################
# Variable to store the output of a command;

Host_Name=$(hostname)
echo "My Host Name is: $Host_Name"

current_directory=$(pwd)
echo "Current Directory: $current_directory"

#############################################
# Constant Variable, means Once you defined a variable and don't wanna change it until end of the scripts.

readonly var=100
echo "var: $var"

var=200
echo "var: $var"


