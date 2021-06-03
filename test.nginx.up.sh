#!/bin/bash

VPC_NAME="alex-vpc"
FR_NAME="alex-ingres"
SUBNET_NAME="alex-subnet"
INSTANCE_NAME="alex-nginx"
INSTANCE_IMAGE_NAME="alex-nginx-image"
INSTANCE_ZONE="europe-west3-c"
INSTANCE_TYPE="f1-micro"
ALERT_VAR="0"

ALERT_VAR=$(gcloud compute networks list | grep -o $VPC_NAME)
if [ "$ALERT_VAR" = "$VPC_NAME" ]
 then
 echo network $ALERT_VAR already exist, please change name
 exit
fi

ALERT_VAR=$(gcloud compute firewall-rules list | grep -o $FR_NAME)
if [ "$ALERT_VAR" = "$FR_NAME" ]
 then
 echo firewall $FR_NAME already exist, please change name
 exit
fi

ALERT_VAR=$(gcloud compute networks subnets list | grep -o $SUBNET_NAME)
if [ "$ALERT_VAR" = "$SUBNET_NAME" ]
 then
 echo subnet $SUBNET_NAME already exist, please change name
 exit
fi

ALERT_VAR=$(gcloud compute instances list | grep -o $INSTANCE_NAME)
if [ "$ALERT_VAR" = "$INSTANCE_NAME" ]
 then
 echo compute instance $INSTANCE_NAME already exist, please change name
 exit
fi


gcloud compute networks create $VPC_NAME --subnet-mode custom

gcloud compute firewall-rules create $FR_NAME --network $VPC_NAME --allow tcp:22,tcp:80,tcp:443,tcp:8080,tcp:8081,tcp:8123,icmp

gcloud compute networks subnets create $SUBNET_NAME --network $VPC_NAME --range 10.0.10.0/24

gcloud compute instances create $INSTANCE_NAME \
--zone=$INSTANCE_ZONE  --machine-type=$INSTANCE_TYPE \
--image-project=centos-cloud --image-family=centos-7 \
--boot-disk-type=pd-standard --boot-disk-size=20GB \
--network $VPC_NAME \
--subnet $SUBNET_NAME \
--metadata-from-file=startup-script=/Users/alanovoy/gcp/sdk/setup.nginx.sh
sleep 10
gcloud beta compute machine-images create $INSTANCE_IMAGE_NAME  \
    --source-instance $INSTANCE_NAME
