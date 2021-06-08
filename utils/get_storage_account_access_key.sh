#!/bin/bash

ARM_ACCESS_KEY=$(az keyvault secret show --name terraform-backend-key --vault-name tstate --query value -o tsv)
echo "ARM_ACCESS_KEY = ${ARM_ACCESS_KEY}"
#echo export ARM_ACCESS_KEY=${ARM_ACCESS_KEY}
