#!/bin/bash
# Mandate creation of both s3 bucket and DynamoDB table
# Ask for region 
helpFunction()
{
   echo ""
   echo "Usage: $0 -region region -bucket-name bucketName -table-name tableName"
   echo -e "\t-region Description of what is parameterA"
   echo -e "\t-bucket-name Description of what is bucketName"
   echo -e "\t-table-name Description of what is tableName"
   exit 1 # Exit script after printing help
}

while getopts "region:bucket-name:table-name::" opt
do
   case "$opt" in
      region ) region="$OPTARG" ;;
      bucket-name ) bucketName="$OPTARG" ;;
      table-name ) tableName="$OPTARG" ;;
      ? ) helpFunction ;; # Print helpFunction in case parameter is non-existent
   esac
done
if [ -z "$bucketName" ] || [ -z "$tableName" ]
then
   echo "bucket-name and table-name cannot be empty";
   helpFunction
fi

BUCKET_EXISTS = aws s3api head-bucket --bucket $bucketName --no-pagniate | grep -q "Not Found"
TABLE_EXISTS = aws dynamodb describe-table --table-name $2 --region $region| grep -q "Not Found"

if $BUCKET_EXISTS
then
  echo "Bucket already exists!"
else 
  if TABLE_EXISTS
  then 

  echo "Creating Bucket named: $bucketName \n Table named: $tableName ..."
  # Call local configure to manage state locally
  cd initalize-remote-state
  terraform init 

  terraform apply -auto-approve -var="region=$region" -var="naming_prefix=$namingPrefix" -var="bucket_name=$bucketName" -var="table_name=$tableName"
  #NOTE: Will it still prompt for values

  # Move that local state to aws s3
  terraform apply -auto-approve -backend-config="remote.hcl"
  else
  echo 
fi