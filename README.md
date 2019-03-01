# Template

A step for Wercker that assumes a role through the AWS CLI.

## Example

```
steps:
    - audienceproject/aws-cli-assume-role:
        aws-access-key-id: $KEY_OF_USER_THAT_WILL_ASSUME_ROLE
        aws-secret-access-key: $SECRET_OF_USER_THAT_WILL_ASSUME_ROLE
        role-arn: "$ARN_OF_ROLE_TO_ASSUME"
```
