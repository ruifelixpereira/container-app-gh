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

## Prepare it first for GitHub Actions

Before you will be able to run GitHub Actions to deploy Container Apps, you need to have the following:
- A GitHub repository with the source code of your app
- An Azure service principal and the credentials for authentication with Azure. It will be used by GitHub Actions to deploy the Container Apps
- A secret in the GitHub repository to store the Azure service principal credentials
- An Azure Resource Group where to deploy Container Apps
- An Azure Container Registry to store the container images of the Container Apps

**Create Azure infra resources**

The following script creates a new Service Principal, a new Resource Group and a Container Registry for container images. The new Resource Group will be used to deploy the Container Registry resource as well as the Container Apps.

You can edit the variables inside the script to customize the names of the resources being created.

```bash
scripts/initial-setup.sh
```

This command will output a file `auth.json` with the service principal credentials that will be used later for the Github Secrets.

**Create the GitHub repository**

Example:

![alt text](assets/repo.png)

**Create environment secrets and variables used by GitHub Actions**

In the GitHub repository, go to "Settings > Code and automation > Environments" and create a new environment with the name `azure`.

![alt text](assets/env.png)

Under this environment, add a new secret with the name `AZURE_CREDENTIALS` and the content of the `auth.json` file.

![alt text](assets/secret.png)

And create the following variables:

- *RESOURCE_GROUP*: the resource group name where the container app will be deployed (e.g., aca-rg-02)
- *LOCATION*: the Azure region where the resources will be deployed (e.g., westeurope)
- *CONTAINER_REGISTRY_NAME*: the name of the Azure Container registry to be created/used to store container images (.e.g., rfpacr02)
- *CONTAINER_APP_NAME*: the name of the container app to be deployed (e.g., aca-gh-actions-02)
- *TARGET_PORT*: the port where the container app will be listening (e.g., 8080)


Example:

![alt text](assets/vars.png)
![alt text](image.png)

**Commit and push everything...***

Finally, commit and push everything to the new repository. Push will trigger 2 actions:
- `build-and-push.yaml` that will build and push the container image to `ghcr.io`
- `build-and-deploy.yaml` that will deploy a new container App to Azure
