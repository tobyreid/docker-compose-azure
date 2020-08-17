# docker-compose-proxy

Demonstrates a docker-compose multi-container application with basic authentication, deployed via terraform to Azure.

user/password is foo/bar

If you fork this repo, you will need to set the following secrets used by the terraform script.

- AZURE_CLIENT_ID
- AZURE_CLIENT_SECRET
- AZURE_SUBSCRIPTION_ID
- AZURE_TENANT_ID

These credentials can be created by running:

`az ad sp create-for-rbac --name "docker-compose-proxy-sp" --role contributor --scopes /subscriptions/{your_subscription_here} --sdk-auth`

*** important - it seems to take a few minutes before the service principal becomes fully active for use by terraform (you will receive HTTP 403 errors)

You will also need to set the following variables for the terraform backend

- TF_ACCESS_KEY
- TF_STORAGE_ACCOUNT_NAME
- TF_CONTAINER_NAME
- TF_KEY

These should be self explanatory - TF_KEY is the path/blob used to save the back end file

If you want to terraform locally, create a `secrets.tfvars` file in the `terraform` folder and set the following:
```
tenant_id="{your value}"
subscription_id="{your value}"
client_id="{your value}"
client_secret="{your value}"

storage_account_name="{your value}"
container_name="{your value}"
access_key="{your value}"
key="{your value}"
```
then run `init.bat`
