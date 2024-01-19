#!/bin/bash

# File name passed as an argument
file=$1

while IFS= read -r bucket
do
  echo "Deleting all objects in bucket: $bucket"
  
  # Run the delete_objects.sh script
  ./s3-empty-bucket.sh --bucket=$bucket
done < "$file"
