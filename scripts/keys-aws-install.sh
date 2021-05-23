#!/bin/bash

# Import all my keys to all regions on the aws account

keys_url=${1:https://yogendra.me/keys}

curl -sSL $keys_url | grep -v ssh-dss | while read key
do
  keyname=$(echo $key | awk {'print $3'} | sed -E s/[^a-z0-9]/_/g)  
  keyfile=/tmp/pubkey-$keyname
  echo $key > $keyfile
  for region in $(aws ec2 describe-regions --query 'Regions[].RegionName' --output text)
  do
    aws ec2 import-key-pair --key-name $keyname --public-key-material fileb://$keyfile --region $region
  done
  rm $keyfile
done
