#!/bin/bash

# Parse the arguments
for i in "$@"
do
case $i in
    --bucket=*)
    bucket="${i#*=}"
    shift
    ;;
    *)
    # Unknown option
    ;;
esac
done

echo "Deleting all objects in bucket: $bucket"

# Delete all objects in the bucket
aws s3 rm s3://$bucket --recursive
