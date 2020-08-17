# docker-compose-proxy

Demonstrates a terraform deployed docker-compose configured azure web app.

If you fork this repo, you will need to set the following secrets used by the terraform script.

- AZURE_CLIENT_ID
- AZURE_CLIENT_SECRET
- AZURE_SUBSCRIPTION_ID
- AZURE_TENANT_ID

These credentials can be created by running:

`az ad sp create-for-rbac --name "docker-compose-proxy-sp" --role contributor --scopes /subscriptions/{your_subscription_here} --sdk-auth`

You will also need to set the following variables for the terraform backend

- TF_ACCESS_KEY
- TF_STORAGE_ACCOUNT_NAME
- TF_CONTAINER_NAME
- TF_KEY

These should be self explanatory - TF_KEY is the path/blob used to save the back end file
