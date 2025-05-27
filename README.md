# ⛑️ Spring App Infra deployment 🛠️



This project securely deploys the repo: https://github.com/ebritt07/spring-app using terraform
- ✅ automatically **cleans your dev environment** each day in the morning, so you don't run up a bill!
- ✅ runs security checks to make sure you are deploying infra safely, and doesn't use any secrets authenticating with AWS

If you'd like to fork your own version of the spring java app, and deploy to your own AWS Account here's how you can do it:

1) Make two AWS accounts. One will be your prod env, and one will be your DEV env.
2) [Create environments in Github](https://docs.github.com/en/actions/managing-workflow-runs-and-deployments/managing-deployments/managing-environments-for-deployment) named "dev" and "prod".
3) [Create an IAM role for your Github repo](https://docs.github.com/en/actions/security-for-github-actions/security-hardening-your-deployments/configuring-openid-connect-in-amazon-web-services) to assume when deploying. Here's an example for the **dev** AWS account connecting to your **dev** Github environment.
    - AWS IAM -> Create Role (type=Custom Trust policy)
    - Set the Trust policy as such:
```
    {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Federated": "arn:aws:iam::{your_dev_account_id}:oidc-provider/token.actions.githubusercontent.com"
            },
            "Action": "sts:AssumeRoleWithWebIdentity",
            "Condition": {
                "StringEquals": {
                    "token.actions.githubusercontent.com:sub": "repo:{your_username}/{your_repo}:environment:dev",
                    "token.actions.githubusercontent.com:aud": "sts.amazonaws.com"
                }
            }
        }
    ]
}
```

4) Fork this repo, and create [Github secret in the appropriate env](https://docs.github.com/en/actions/security-for-github-actions/security-guides/using-secrets-in-github-actions#creating-secrets-for-an-environment), to store the IAM role you created as  `AWS_ROLE_ARN`
    - note, that [role ARN's are not considered secrets](https://docs.aws.amazon.com/IAM/latest/UserGuide/reference-arns.html). But, this project keeps it secret anyway