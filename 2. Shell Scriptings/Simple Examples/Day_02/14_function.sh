#!/bin/bash




########### Functions:



# example 1:
echo "example 1: "
function myfun1 {
        echo "This is my function 1"

}
myfun1

# another way write the function
myfunc2() {
        echo "This is my function 2"
}
myfunc2



# example 2:
addition() {
        num1=$1
        num2=$2

        let num=$num1+$num2
        echo "sum of $num1 and $num2 is: $num"
}
addition 10 20

