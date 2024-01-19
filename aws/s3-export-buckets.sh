#!/bin/bash

# Threshold in MB
THRESHOLD=10000

# Total data transferred in MB
total=0

# Array of completed buckets
completed=()

# Array of bucket names passed as arguments
buckets=("$@")

for bucket in "${buckets[@]}"; do
  # Run the first script and get the size of the data transferred
  ./bucket_actions.sh $bucket
  size=$?

  # Add the size to the total
  total=$((total + size))

  # Check if the total exceeds the threshold
  if (( total > THRESHOLD )); then
    echo "Threshold reached. Stopping the script."

    # Prepare the report
    echo "Completed buckets:"
    for comp in "${completed[@]}"; do
      echo $comp
    done

    exit 1
  fi

  # Add the bucket to the completed array
  completed+=($bucket)
done

# Prepare the final report
echo "Completed buckets:"
for comp in "${completed[@]}"; do
  echo $comp
done
