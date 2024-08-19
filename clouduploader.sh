#!/bin/bash

# A script that will copy a file into s3 bucket in AWS.

bucket_name='mycloudcoderepo'

: <<'END'
setup() { 
    # Install az cli
    curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
    # Login
    az login --use-device-code
    echo "You're logged in."
}
END

# take an argument with $1 and check if the file exists
# Eg. \Desktop\screenshots\
# test path - /Users/remi-mac/Desktop/Screenshots/ec2_instance_t3medium.png
# validate if the local file exists
function check_file () {
  # echo "The value of the first argument to the script : $1"
  # filename=$1
  if [ -f $filename ]; then
    echo "The file - $filename - exists"
    return 0  # Return true (success)
  else
    return 1  # Return false (failure)
  fi
}

# aws access keys is already set in my terminal
# aws s3 list
# aws command to upload to s3 from aws cli
# aws s3 ls
# aws sts get-caller-identity
# aws s3 cp /path/to/source s3://bucket-name/ --recursive
# aws s3 cp ./testfile.txt s3://mycloudcoderepo/ # --recursive
# try catch in bash

# validate if s3 bucket exist
check_storage () { 
 # List storage names and confirm the one we need is available
  # aws s3api list-objects --bucket bucket-name --query 'Contents[].Key' --output text > output-file.txt
  # aws s3 ls s3://bucketnametotry
  # BUCKET_EXISTS=$(aws s3api head-bucket --bucket $bucket_name 2>&1 || true)
  # return $BUCKET_EXISTS  # this returns a numeric value
  # echo $BUCKET_EXISTS
  # echo $bucket_name
  if [[ -z $(aws s3api head-bucket --bucket $bucket_name 2>&1) ]]; then
    echo "AWS S3 bucket - $bucket_name exists"
    return 0  # Return true (success)
  else
    # echo "bucket does not exist or permission is not there to view it."
    return 1  # Return false (failure)
  fi
}
# if [[ ! -z $(aws s3api list-buckets --query 'Buckets[?Name==`bucket-name`]' --output text) ]]; then
#   echo "Bucket Exists"
# fi

# upload file to AWS S3
upload_file () {
  check_file $filename
  if [[ $? -eq 0 ]]; then
    check_storage
    if [[ $? -eq 0 ]]; then
      echo "Uploading the file $filename to S3: $bucket_name ..."
      # aws s3 cp ./testfile.txt s3://mycloudcoderepo/ # --recursive
      aws s3 cp $filename s3://$bucket_name/
    else
      echo "Error on the S3 bucket. Check if it exists..."
    fi
  else
    echo "check that the file and filepath is correct"
  fi
}

: <<'END'
# Create the resource group
create_resource_group () {
    echo "Creating resource group: $resource_group in $selected_region"
    az group create -g $resource_group -l $selected_region | grep provisioningState
}
END




# main 
# setup
# check_file
# s3check=$(check_storage)
# echo $s3check
# echo "The value of the first argument to the script : $1"
filename=$1
upload_file $filename
# returnv=$(check_file $filename)
# echo $returnv


