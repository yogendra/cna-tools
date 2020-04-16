#!/usr/bin/env bash
# USAGE: k8s-cluster-lb.sh cluster_name "master vms list" "subnet list" "vpc_id"
# TIP: terraform subnets list 
# "$(terraform output infrastructure_subnet_ids | tr -d ',' | tr  '\n' ' ')"
# TIP: terraform vpc-id
# "$(terraform output vpc_id)"

cluster_name=$1
cluster_uuid=$2
security_group=${3:-default}


master_vms=$(aws ec2 describe-instances --filters Name=tag-key,Values=kubernetes.io/cluster/service-instance_${cluster_uuid} --filter tag:instance_group,Values=master --query "Reservations[*].Instances[*].InstanceId" --output text)

subnets="$(terraform output infrastructure_subnet_ids | tr -d ',' | tr  '\n' ' ')"
vpc_id="$(terraform output vpc_id)"
security_groups=$(aws ec2 describe-security-groups --group-name default --query "SecurityGroups[0].GroupId")

lb_name="k8s-master-${cluster_name}"
target_group="${lb_name}-tg-8443"

if ! aws elbv2 describe-load-balancers --name ${lb_name} &> /dev/null; then
  aws elbv2 create-load-balancer --name ${lb_name} --type network --subnets ${subnets} --scheme internal
fi
lb_arn=$(aws elbv2 describe-load-balancers --names ${lb_name} --query "LoadBalancers[0].LoadBalancerArn")

if ! aws elbv2 describe-target-groups --name ${target_group} &> /dev/null; then
  aws elbv2 create-target-group --name ${target_group} --protocol TCP --port 8443 --vpc-id ${vpc_id}
else
target_group_arn=$(aws elbv2 describe-target-groups --name ${traget_group} --query "TargetGroups[0].TargetGrsoupArn")

aws elbv2 describe-target-health --target-group-arn ${target_group_arn} --query 'TargetHealthDescriptions[*].Target.Id' --output text  | while read exiting_target; do
  target_id="Id:${exiting_target}"
  aws elbv2 deregister-targets --target-group-arn ${target_group_arn} --targets $target_id
done

master_vms_ids=$(echo $master_vms | tr ' ' '\n' | sed 's/^i-/Id:i-/' | tr '\n' ' ')
aws elbv2 register-targets --target-group-arn ${target_group_arn} --targets ${master_vm_ids}


aws elbv2 create-listener --load-balancer-arn ${lb_arn} --protocol TCP --port 8443  \
--default-actions Type=forward,TargetGroupArn=${target_group_arn}

