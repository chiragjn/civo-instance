# Civo ml-instance-workspace

## Getting started

- input your civo API key into a file named "terraform.tfvars" in the root directory
- e.g "civo_token = "YOUR_KEY"

To deploy simply run:

- terraform init
- terraform plan
- terraform apply

Once initally created, you can change the "create_volume" flag to false, and when you recreate this terrafrom repository the data stored in the persisted volume will be remounted to the instance.

## Removing the instance (Keeping persisted data)

To scale down the enviroment you can simply set the "create_instance" variable to false and run:
- terraform apply

To scale down the instance and persist the data.

## Removing the entire deployment
If you'd like to remove the entire deployment, simply run:
- terraform destroy


