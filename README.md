Example to setup a publicly accessible RDS Cluster on AWS using terraform. 
This example does not use production quality security. 
The RDS instances are deployed on the default public subnets and are behind a security group which allows all traffic.
Used only for spinning up DB for side projects which are not critical.

### Steps


1. Create buckets and dynamodb table for storing terraform remote state.
```bash
cd remote_state
terraform init
terraform apply -var-file=var_file_with_secrets.tfvars
```
You can use environment variables, or command line arguments instead of storing secrets in a var file.

2. Create common networking and root domain zone for __dev__ environment.
```bash
cd networking
terraform init
terraform workspace new dev
terraform apply -var-file=var_file_with_secrets.tfvars
```

3. Setup domain name records.

In the output of step 2, you should see list of name servers for root domain name. I tend to use a resources.example.com
as the root domain for all AWS resources. example.com is managed my route53 in my case. So you want to setup name servers for resources subdomain.
On you DNS management tool, setup NS records for resources.example.com with values from the output. 

4. Create RDS Cluster and route53 records in dev environment.
```bash
cd rds
terraform init
terraform workspace new dev
terraform apply -var-file=var_file_with_secrets.tfvars
```

Output of above should contain writer and reader endpoints for your new RDS Cluster. But you should use the domain records to connect
to RDS instances.

### Notes
1. This project is for demonstration purposes only and does not use recommended security guidelines.
2. Demonstrates use of workspaces.
3. Demonstrates use of remote state store using S3 backend.
4. _Don't forget to tear down rds cluster after use_.
5. Terraform takes care of creating environment specific state files.