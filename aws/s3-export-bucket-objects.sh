#!/bin/bash

# Parse the arguments
for i in "$@"
do
case $i in
    --bucket=*)
    bucket="${i#*=}"
    shift
    ;;
    --target_dir=*)
    target_dir="${i#*=}"
    shift
    ;;
    *)
    # Unknown option
    ;;
esac
done

echo "Processing bucket: $bucket"

# Create a directory for the bucket in the target directory
mkdir -p $target_dir/$bucket

# Copy all objects from the bucket
aws s3 cp s3://$bucket $target_dir/$bucket --recursive

# Calculate the size of the data transferred
size=$(du -sm $target_dir/$bucket | cut -f1)
echo "Size of data transferred: $size MB"

# Zip the folder
tar -czf $target_dir/$bucket.tar.gz -C $target_dir $bucket

# Delete the folder
rm -rf $target_dir/$bucket

echo "Completed bucket: $bucket"

# Return the size of the data transferred
exit $size
