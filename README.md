# Civo ml-instance-workspace

## Getting started

- input your civo API key into a file named "terraform.tfvars" in the root directory
- e.g "civo_token = "YOUR_KEY"

To deploy simply run:

- terraform init
- terraform plan
- terraform apply

Once initally created, you can change comment out the volume creation, and when you recreate this terrafrom repository the data stored in the persisted volume will be remounted to the instance.

## Removing the entire deployment
If you'd like to remove the entire deployment, simply run:
- terraform destroy


TODO:

- [ ] Reserved IP