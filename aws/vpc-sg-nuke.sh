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

# Get the security groups for the VPC
security_groups=$(aws ec2 describe-security-groups --filters Name=vpc-id,Values=$vpc_id --query 'SecurityGroups[*].GroupId' --output text)

for sg in $security_groups; do
  echo "Processing security group: $sg"

  # Get the rules associated with the security group
  ingress_rules=$(aws ec2 describe-security-groups --group-ids $sg --query 'SecurityGroups[*].IpPermissions[*]' --output json)
  egress_rules=$(aws ec2 describe-security-groups --group-ids $sg --query 'SecurityGroups[*].IpPermissionsEgress[*]' --output json)

  # Delete all ingress rules
  if [ "$ingress_rules" != "[]" ]; then
    for rule in $(echo "${ingress_rules}" | jq -r '.[] | @base64'); do
      aws ec2 revoke-security-group-ingress --group-id $sg --ip-permissions "$(echo "${rule}" | base64 --decode)"
    done
  fi

  # Delete all egress rules
  if [ "$egress_rules" != "[]" ]; then
    for rule in $(echo "${egress_rules}" | jq -r '.[] | @base64'); do
      aws ec2 revoke-security-group-egress --group-id $sg --ip-permissions "$(echo "${rule}" | base64 --decode)"
    done
  fi

  # Delete the security group
  aws ec2 delete-security-group --group-id $sg

  echo "Deleted security group: $sg"
done
