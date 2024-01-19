#!/bin/bash

# Parse the arguments
for i in "$@"
do
case $i in
    --vpc_id=*)
    vpc_id="${i#*=}"
    shift
    ;;
    *)
    # Unknown option
    ;;
esac
done

echo "Processing VPC: $vpc_id"

# Delete all subnets in the VPC
subnets=$(aws ec2 describe-subnets --filters Name=vpc-id,Values=$vpc_id --query 'Subnets[*].SubnetId' --output text)
for subnet in $subnets; do
  aws ec2 delete-subnet --subnet-id $subnet
done

# Disassociate and release all Elastic IPs in the VPC
addresses=$(aws ec2 describe-addresses --filters Name=domain,Values=vpc --query 'Addresses[*].AllocationId' --output text)
for address in $addresses; do
  aws ec2 release-address --allocation-id $address
done

# Delete all route tables in the VPC
route_tables=$(aws ec2 describe-route-tables --filters Name=vpc-id,Values=$vpc_id --query 'RouteTables[*].RouteTableId' --output text)
for rt in $route_tables; do
  aws ec2 delete-route-table --route-table-id $rt
done

