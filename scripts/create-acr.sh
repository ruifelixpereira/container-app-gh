#!/bin/bash

# Variables
location="westeurope"
acrResourceGroup="registry-rg"
acrName="rfpacr"

#
# Create/Get a resource group.
#
rg_query=$(az group list --query "[?name=='$acrResourceGroup']")
if [ "$rg_query" == "[]" ]; then
    echo -e "\nCreating Resource group '$acrResourceGroup'"
    az group create --name ${acrResourceGroup} --location ${location}
else
    echo "Resource group $acrResourceGroup already exists."
fi

#
# Create/Get a container registry
#
cr_query=$(az acr list --query "[?name=='$acrName']")
if [ "$cr_query" == "[]" ]; then
    echo -e "\nCreating container registry '$acrName'"
    az acr create -n $acrName -g $acrResourceGroup --sku Basic
else
    echo "Container registry $acrName already exists."
fi

