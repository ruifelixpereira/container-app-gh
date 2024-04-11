# Sample Container App scenario

Azure Container App to run a simple HTTP nodejs app and using Github Actions to deploy revision into ACA.

References:
- https://learn.microsoft.com/en-us/azure/container-apps/github-actions
- https://github.com/Azure-Samples/containerapps-albumapi-javascript


The action supports the following scenarios:
- Build from a Dockerfile and deploy to Container Apps
- Build from source code without a Dockerfile and deploy to Container Apps. Supported languages include .NET, Java, Node.js, PHP, and Python
- Deploy an existing container image to Container Apps


## Run and test it locally

Using npm:

```bash	
cd src
npm run start
```

Or using Docker:

```bash
cd src
docker build -t albumapi .
docker run -p 8080:8080 albumapi
```

Test in your bwoser with http://localhost:8080/albums

Or using curl:

```bash
curl -X GET -H "Content-Type: application/json" http://localhost:8080/albums
```

## Prepare it firts for GitHub Actions

Bfore you will be able to run GitHub Actions to deploy Container Apps you needs to have the following:
- A GitHub repository with the source code of your app
- An Azure service principal and the credentials for authentication with Azure
- A secret in the GitHub repository to store the Azure service principal credentials
- An Azure Container Registry to store the container images of the Container Apps

1. Create a GitHub repository, commit and push everyhting to it.

The push will trigger the action build-and-osuh.yaml that will build ans push the container image to ghcr.io:

![alt text](image.png)

2. Create a new service principal on Azure that will be used by GitHub Actions to deploy new Container Apps:

```bash
./scripts/create-sp.sh
```

This command will output a file `auth.json` with the service principal credentials that will be used later on in the Github Secrets.

3. Create a secret with your Azure crdentials

In the GitHub repository, go to Settings > Security > Secrets and create a new secret with the name `AZURE_CREDENTIALS` and the content of the `auth.json` file.

![alt text](image-1.png)

4. Create a new Azure Container Registry to store the container images of the Container Apps

```bash
./scripts/create-acr.sh
```

## Create infrastructure

