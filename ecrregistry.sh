#!/bin/bash 

varInit(){
   AWS_ACCOUNT={ACCOUNT ID} 
   AWS_REGION=us-east-1
   DOCKER_REGISTRY_SERVER=https://${AWS_ACCOUNT}.dkr.ecr.${AWS_REGION}.amazonaws.com
   DOCKER_USER=AWS
   DOCKER_PASSWORD=`aws ecr get-login --region ${AWS_REGION} --registry-ids   ${AWS_ACCOUNT} | cut -d' ' -f6`
}


ecrConnect(){
   kubectl delete secret aws-registry || true
   kubectl create secret docker-registry aws-registry \
      --docker-server=$DOCKER_REGISTRY_SERVER \
      --docker-username=$DOCKER_USER \
      --docker-password=$DOCKER_PASSWORD \
      --docker-email=bob.dickerson@business.com
   kubectl patch serviceaccount default -p '{"imagePullSecrets":[{"name":"aws-registry"}]}'

}

varInit
ecrConnect


