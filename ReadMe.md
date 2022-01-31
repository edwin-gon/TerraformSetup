# Terraform Remote State Bootstrapping

This repository contains list of approaches from large to least amount of effort in setting up remote state for Terraform.

**Note:** All code examples are all done using Amazon Web Services  ( **i.e** S3 to store the state and DyanmoDb to manage locking.

## Approaches

1. Manually Creation (ClickOps)
2. Partial Terraform
3. Leveled Up Terraform 
4. Terragrunt 

## Gotchas (Situation : Gist)

1. Manual Creation 
- Error prone
- Time Consuming
2. Partial Terraform
- Requires some upfront set up to download dependenices. 
- Requires manual execution calls 
3. Shell Script
- Automated however multiple scripts to manage and lets stand on the shoulders of giants.
4. Terragrunt 
- Not an automated fashion for how to delete/rename remote state resources 
- May not want to use other Terragrunt features