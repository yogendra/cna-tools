#!/usr/bin/env bash
# USAGE: k8s-cluster-lb.sh vpc_id cluster_name cluster_uuid subnet_types [security_group_name]
set -e 

vpc_id=$1
cluster_name=$2
cluster_uuid=$3
subnet_type=$4
security_group=${5:-default}


echo fetching subnets
subnets=($(aws ec2 describe-subnets --filters "Name=vpc-id,Values=${vpc_id}" "Name=tag:Name,Values=*${subnet_type}*" --query "Subnets[*].SubnetId" --output text))

echo fetching security group id
security_group_id=$(aws ec2 describe-security-groups --filters  "Name=vpc-id,Values=${vpc_id}" "Name=group-name,Values=${security_group}" --query "SecurityGroups[0].GroupId" --output text)

lb_name=${lb_name:-k8s-master-${cluster_name}}
target_group=${target_group:-${lb_name}-tg-8443}
cat <<EOF
cluster name:      ${cluster_name}
cluster_uuid:      ${cluster_uuid}
vpc:               ${vpc_id}  
lb:                ${lb_name}
subnet ids:        ${subnets[@]}
target group name: ${target_group}
security group:    ${security_group}[${security_group_id}]
EOF
echo -n "Review information above and press control-c to quit/cancel. Press enter to proceed"
read quit

lb_created=0
if ! aws elbv2 describe-load-balancers --names ${lb_name} &> /dev/null; then
  echo lb creation
  lb_created=1
  aws elbv2 create-load-balancer --name ${lb_name} --type network  --scheme internal  --subnets ${subnets}
fi
echo get lb arn
lb_arn=$(aws elbv2 describe-load-balancers --names ${lb_name} --query "LoadBalancers[0].LoadBalancerArn"  --output text)

if ! aws elbv2 describe-target-groups --names ${target_group} &> /dev/null; then
  echo create target group
  aws elbv2 create-target-group --name ${target_group} --protocol TCP --port 8443 --vpc-id ${vpc_id}
fi
echo get target group arn
target_group_arn=$(aws elbv2 describe-target-groups  --names ${target_group}  --query "TargetGroups[0].TargetGroupArn" --output text)
echo target group arn: $target_group_arn

# existing_targets=($(aws elbv2 describe-target-health --target-group-arn ${target_group_arn} --query 'TargetHealthDescriptions[*].Target.Id' --output text ))
# for existing_target in  "${existing_targets[@]}"
# do
#   echo deregister exiting host $exiting_target
#   target_id="Id=${exiting_target}"
#   aws elbv2 deregister-targets --target-group-arn ${target_group_arn} --targets $target_id
# done


echo register all master vms
aws ec2 describe-instances --filters "Name=vpc-id,Values=${vpc_id}" \
  "Name=instance-state-name,Values=running" \
  "Name=tag:job,Values=master" \
  "Name=tag-key,Values=kubernetes.io/cluster/service-instance_${cluster_uuid}" \
  --query "Reservations[*].Instances[*].InstanceId" \
  --output text | while read vm ; do
  echo $vm: register
  aws elbv2 register-targets --target-group-arn ${target_group_arn} --targets Id=$vm
done


echo Add Listner
aws elbv2 create-listener --load-balancer-arn ${lb_arn} --protocol TCP --port 8443 --default-actions Type=forward,TargetGroupArn=${target_group_arn}



echo -e "\n${green}Adding kubernetes tags to public subnets for LoadBalancer type service"
for subnet in "${subnets[@]}"
do  
  aws ec2 create-tags --resources "$subnet" --tags Key="kubernetes.io/cluster/service-instance_${cluster_uuid}",Value="shared"
done
