# 2-tier-web-app-terraform

## Overview

The terraform configuration launches a new VPC, a public subnet, 2 private subnets, internet gateway, nat gateway, route tables, security groups, ec2, rds (mariadb).

The EC2 instance is in the public subnet and will pre-install awscli, Apache and PHP using the User-data passed in. It will also download wordpress.

The RDS is not Multi-AZ (as of now), the 2nd private subnet is only launched because DB-Subnet-Group doesnt work with only 1 subnet. We have configured the RDS to only using us-east-1a for now (1st private subnet). The 2nd private subnet also isnt attached to the NAT gateway.

The RDS uses the default KMS key (for RDS) to generate the password and store in the Secrets Manager. You can also create your own key by going to AWS console > KMS. Then you can reference that key in the terraform configuration as shown in the first 3 lines of file "rds.tf" and then also uncomment the "master_user_secret_kms_key_id" argument.

After running "terraform apply", SSH into the EC2 instance, run `aws configure` and configure it. Then rename wp-config-sample.php to wp-config.php, configure the database details, then go to the address and install Wordpress. Thats all.

You may also configure AWS credentials without running the command `aws configure`:
```
export AWS_ACCESS_KEY_ID=my-20-digit-id
export AWS_SECRET_ACCESS_KEY=my-40-digit-secret-key
export AWS_DEFAULT_REGION=us-east-1
```

To get database details like hostname, etc.:
```
aws rds describe-db-instances  
aws secretsmanager list-secrets  #get the secret name which is created for the RDS
aws secretsmanager describe-secret --secret-id 'rds!3434343'
aws secretsmanager get-secret-value --secret-id 'rds!344343'   #retreive secret value
```

Test from ec2 instance whether RDS is accessible:

`nslookup database-1.ccsx.us-east-1.rds.amazonaws.com`

`telnet database-1.ccsx.us-east-1.rds.amazonaws.com 3306`

`mysql -h database-1.ccsx.us-east-1.rds.amazonaws.com -u admin -p`

## Diagram of infra:
![2tierapp](https://github.com/user-attachments/assets/d355400f-4abe-40b4-bef8-aff2a2bb53f3)



