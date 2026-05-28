# aws-iam-users-roles

Terraform project for managing IAM users, groups, roles, and custom policies.

## Resources Managed

| Resource | Description |
|---|---|
| `aws_iam_user` | IAM users |
| `aws_iam_group` | IAM groups and group memberships |
| `aws_iam_role` (service) | Roles assumed by AWS services (Lambda, EC2, ECS, etc.) |
| `aws_iam_role` (cross-account) | Roles assumed from other AWS accounts |
| `aws_iam_role` (OIDC) | Roles for federated identities (GitHub Actions, SSO) |
| `aws_iam_policy` | Custom managed policies |

## Usage

All resources are driven by variables. Define them in a `.tfvars` file or pass via `tf_vars` in the workflow.

### Example: Users and Groups

```hcl
groups = {
  developers = {
    managed_policy_arns = ["arn:aws:iam::aws:policy/PowerUserAccess"]
  }
  read-only = {
    managed_policy_arns = ["arn:aws:iam::aws:policy/ReadOnlyAccess"]
  }
}

users = {
  alice = { groups = ["developers"] }
  bob   = { groups = ["read-only"] }
}
```

### Example: Service Role

```hcl
service_roles = {
  lambda-execution = {
    description      = "Execution role for Lambda functions"
    trusted_services = ["lambda.amazonaws.com"]
    managed_policy_arns = [
      "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
    ]
  }
}
```

### Example: Cross-Account Role

```hcl
cross_account_roles = {
  ops-assume-role = {
    description         = "Allow ops account to assume into this account"
    trusted_account_ids = ["123456789012"]
    require_mfa         = true
    managed_policy_arns = ["arn:aws:iam::aws:policy/ReadOnlyAccess"]
  }
}
```

### Example: GitHub Actions OIDC Role

```hcl
oidc_roles = {
  github-actions-deploy = {
    description       = "Role assumed by GitHub Actions for deployments"
    oidc_provider_arn = "arn:aws:iam::ACCOUNT_ID:oidc-provider/token.actions.githubusercontent.com"
    oidc_subjects     = ["repo:rdavis542/my-repo:ref:refs/heads/main"]
    managed_policy_arns = [
      "arn:aws:iam::aws:policy/PowerUserAccess"
    ]
  }
}
```

> The OIDC provider for GitHub Actions must exist before creating OIDC roles.
> See [aws-github-oidc](../aws-github-oidc) for provisioning it.

### Example: Custom Policy

```hcl
custom_policies = {
  s3-read-specific-bucket = {
    description = "Read access to the artifacts bucket"
    policy_json = jsonencode({
      Version = "2012-10-17"
      Statement = [{
        Effect   = "Allow"
        Action   = ["s3:GetObject", "s3:ListBucket"]
        Resource = [
          "arn:aws:s3:::my-artifacts-bucket",
          "arn:aws:s3:::my-artifacts-bucket/*"
        ]
      }]
    })
  }
}
```

## Local Development

```bash
cd terraform
terraform init
terraform plan
terraform apply
```

## CI/CD

| Workflow | Trigger | Action |
|---|---|---|
| `tf-create.yml` | Push to `main`, PR, manual | Plan on PR; Apply on push/dispatch |
| `tf-destroy.yml` | Manual only | Destroy with "destroy" confirmation |
| `tfsec.yml` | Push to `main`, PR | Security scanning via tfsec |

## State

Stored in S3: `tf-state-replication-source-350726165848/terraform-iam-users-roles.tfstate`
