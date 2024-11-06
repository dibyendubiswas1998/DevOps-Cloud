#/bin/bash



############# String Operation

var="Hey Buddy, How Are YOU?"

# Length:
varLength=${#var}
echo "Length of var: $varLength"

# Upper Case:
upp=${var^^}
echo "Upper Case: $upp"

# Lower Case:
low=${var,,}
echo "Lower case: $low"

# Replace a word:
new_var=${var/Buddy/Wrold}
echo "Original String: $var"
echo "After replace: $new_var"

# Slicing:
slice=${var:4:5}
echo "Slicing: $slice"

