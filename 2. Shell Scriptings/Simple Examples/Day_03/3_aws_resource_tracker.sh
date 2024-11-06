#!/bin/bash




##################### AWS Resource Tracker:
# This scripts report the AWS resource usages:


# AWS S3
# AWS EC2
# AWS Lambda
# AWS IAM users


# list of S3 buckets:
list_s3=$(aws s3 ls)
echo "List of S3 Buckets:"
echo "$list_s3"
echo


# list of ec2 instances:
#list_ec2=$(aws ec2 describe-instances) # get all the infomation of all ec2 in very describe way

list_ec2_ids=$(aws ec2 describe-instances | jq '.Reservations[].Instances[].InstanceId') # get only ec2 ids, jq is for json parser
echo "List of Ec2 instances:"
# echo "$list_ec2"
echo "$list_ec2_ids"
echo


# list of aws lambda function:
list_lambda=$(aws lambda list-functions)
echo "List of Lambda Function:"
echo "$list_lambda"
echo



# list of IAM users;
list_iam=$(aws iam list-users)
echo "List of IAM users:"
echo "$list_iam"
echo