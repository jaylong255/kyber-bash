#!/bin/bash

echo " Geting a list of all buckets"
buckets=$(aws s3api list-buckets --query "Buckets[].Name" --output text)


echo "Looping through each bucket, gett its size and printing it along with the bucket name"
for bucket in $buckets; do
  size=$(aws s3 ls s3://$bucket --recursive | awk 'BEGIN {total=0}{total+=$3}END{print total/1024/1024" MB"}')
  echo -e "$size\t$bucket"
done
