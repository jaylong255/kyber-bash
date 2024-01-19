#!/bin/bash

# Parse the arguments
for i in "$@"
do
case $i in
    --sg_id=*)
    sg_id="${i#*=}"
    shift
    ;;
    *)
    # Unknown option
    ;;
esac
done

echo "Processing security group: $sg_id"

# Get the network interfaces associated with the security group
network_interfaces=$(aws ec2 describe-network-interfaces --filters Name=group-id,Values=$sg_id --query 'NetworkInterfaces[*].NetworkInterfaceId' --output text)

for ni in $network_interfaces; do
  echo "Network interface: $ni"

  # Get the description of the network interface
  description=$(aws ec2 describe-network-interfaces --network-interface-ids $ni --query 'NetworkInterfaces[*].Description' --output text)

  echo "Description: $description"
done
