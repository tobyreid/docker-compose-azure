# docker-compose-azure

## Summary
This repository demonstrates development and deployment of a multi container application in Microsoft Azure via Terraform where the containers come from both DockerHub and Azure Container Registry.

The two containers are a 'hello world' style application held in a private registry, and a basic authentication container that gates all requests using basic authentication held in a public registry.

This repository uses github actions to build and deploy the multi-container application to Microsoft Azure.

## Local Development

Assuming you have docker and docker-compose installed, you should be able to run

`docker-compose build`

`docker-compose up`

This will serve a site on port 8000.  You will need to use the username/password `foo/bar` to access the next page.

The auth container is from [beevelop/nginx-basic-auth](https://hub.docker.com/r/beevelop/nginx-basic-auth) - further config instructions can be found there.

## Cloud Development

When forking this repository, it assumes you already have a Microsoft Azure account and that you already have an Azure Container Registry setup with admin access enabled.  It also assumes you have a blob storage account setup with access to the keys.

You will also need an AAD service principal to allow the terraform script to build and deploy this solution.  This can be created by running the following command - with your subscription guid replaced as appropriate:

`az ad sp create-for-rbac --name "docker-compose-proxy-sp" --role contributor --scopes /subscriptions/{your_subscription_id_here} --sdk-auth`

Make a note of the output - *important* - it seems to take a few minutes before the service principal becomes fully active for use by terraform. You may receive HTTP 403 errors for a short period of time if this is the case.

You will need to set the following github secrets:

Secret | Description
-------|--------------------
AZURE_CLIENT_ID | Use output of service principal
AZURE_CLIENT_SECRET | Use output of service principal
AZURE_SUBSCRIPTION_ID | Use output of service principal
AZURE_TENANT_ID| Use output of service principal
DOCKER_USERNAME | Your azure ACR prefix - e.g. contoso
DOCKER_PASSWORD | Your ACR password e.g. adminpassword
DOCKER_REGISTRY | Your ACR domain - e.g. contoso.azurecr.io
TF_ACCESS_KEY | The Azure storage account access key
TF_STORAGE_ACCOUNT_NAME | The azure storage account name
TF_CONTAINER_NAME | The azure storage account container name
PRODUCT_NAME | The prefix you would like to set for your deployed azure services - eg. `dcp-pxy`

## Locally deploying to Azure

If you want to terraform Auzre locally, create a `secrets.tfvars` file in the `terraform` folder and set the following:


```
tenant_id="{your value}"
subscription_id="{your value}"
client_id="{your value}"
client_secret="{your value}"

storage_account_name="{your value}"
container_name="{your value}"
access_key="{your value}"

# or whatever environment/branch you're on
key="master.tfstate"

acr_domain = "contoso.azurecr.io"
acr_admin_username = "contoso"
acr_admin_password = "{your value}"
app-hello-tag = "{your_acr_image_and_tag}"
product_name = "dcp-pxy"
```
then run `apply.bat`

'# Changing the password

If you want to set a new password in appsettings, use a service such as https://hostingcanada.org/htpasswd-generator and save a new app setting in main.tf using 'apache specific salt md5'
