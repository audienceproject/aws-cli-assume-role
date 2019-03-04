#!/bin/bash

aws_key=$WERCKER_AWS_CLI_ASSUME_ROLE_AWS_ACCESS_KEY_ID
aws_secret=$WERCKER_AWS_CLI_ASSUME_ROLE_AWS_SECRET_ACCESS_KEY
role_arn=$WERCKER_AWS_CLI_ASSUME_ROLE_ROLE_ARN

if [[  -z $aws_key || -z $aws_secret ]]; then
  echo "Please specify the AWS access key id and secret of the user that will assume the role"
  exit 1
fi

if [[  -z $role_arn ]]; then
	echo "Please specify a role to assume"
	exit 1
fi

# Create AWS credentials files
mkdir -p ~/.aws

cat <<EOT >> ~/.aws/credentials
[default]
aws_access_key_id = $aws_key
aws_secret_access_key = $aws_secret
EOT

cat <<EOT >> ~/.aws/config
[profile assumedrole]
source_profile = default
role_arn = $role_arn
EOT

# Store assumed role in global env so we don't need to specify the '--profile' option in cli commands
cat <<EOT >> ~/.bash_profile
unset AWS_ACCESS_KEY_ID
unset AWS_SECRET_ACCESS_KEY
export AWS_DEFAULT_PROFILE=assumedrole
EOT

source ~/.bash_profile

# Check that we can assume the specified role
echo "Checking that $aws_key can assume $role_arn..."
UUID=$(cat /proc/sys/kernel/random/uuid)
if aws sts assume-role --role-arn $role_arn --role-session-name $UUID; then
    echo "Sucessfully assumed role $role_arn"
else
    echo "Error assuming role $role_arn" && exit 1
fi
