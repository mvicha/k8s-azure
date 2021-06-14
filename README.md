Clone repository

Create local directory where to hold variables
mkdir -p k8s-azure/.azure k8s-azure/.kube k8s-azure/.ssh

Run docker_env
docker container run --name casopractico2 -it -v ${PWD}/k8s-azure/.azure:/root/.azure -v ${PWD}/k8s-azure/.kube:/root/.kube -v ${PWD}/k8s-azure/.ssh:/root/.ssh -v ${PWD}/k8s-azure:/SAFE_VOLUME mvilla/casopractico2:latest /bin/bash

cd /SAFE_VOLUME/terraform
az login
terraform init
terraform plan -out plan.out
terraform apply plan.out


kubectl taint nodes master node-role.kubernetes.io/master:NoSchedule-
