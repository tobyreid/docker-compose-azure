REM - for local testing
terraform init -backend-config="secrets.tfvars"
terraform plan -var-file="secrets.tfvars"
ECHO are you sure? - press any key to continue or CTRL+C to exit
pause
terraform apply -var-file="secrets.tfvars" -auto-approve
