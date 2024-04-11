#!/bin/bash

# Variables
appName="aca-gh-actions-lab"

# Get the subscription ID
subscriptionId=$(az account show --query id -o tsv)

# Create a service principal
#az ad sp create-for-rbac --name $appName --role contributor --scopes /subscriptions/$subscriptionId}/resourceGroups/{resource-group} --json-auth
az ad sp create-for-rbac --name $appName --role contributor --scopes /subscriptions/$subscriptionId --json-auth > auth.json
