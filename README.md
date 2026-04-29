# Project # 25 - chime-sdk-monitoring-terraform

Terraform module that provisions baseline AWS infrastructure for working with the Amazon Chime SDK: an IAM role for Chime SDK service access, an SNS topic for alerts, two CloudWatch alarms (4xx errors and Chime API usage), and a placeholder API Gateway HTTP API.

Intended as a starting scaffold. The API Gateway has no routes or integrations defined yet, and the IAM policy is intentionally broad. Both should be tightened before production use.

## What It Provisions

- **IAM role and policy** (`ChimeSDKRole` / `ChimeSDKPolicy`) — grants `chime:*` for Chime SDK access and CloudWatch Logs permissions
- **SNS topic** (`ChimeSDKAlerts`) — receives alarm notifications. Subscriptions (email, Slack, PagerDuty) are configured separately
- **CloudWatch alarm: `unauthorized_access_alarm`** — fires when `AWS/ApiGateway 4XXError` >= 5 over a 5-minute period
- **CloudWatch alarm: `usage_limit_alarm`** — fires when the configured Chime API call rate metric >= 1000 over a 5-minute period
- **API Gateway HTTP API** (`chime_api`) — empty HTTP API with an auto-deploy stage (`chime_stage`)

## Stack

Terraform · AWS Chime SDK · IAM · SNS · CloudWatch Alarms · API Gateway v2 (HTTP)

## Repository Layout

```
chime-sdk-monitoring-terraform/
├── main.tf
├── .gitignore
└── README.md
```

## Outputs

- `chime_api_endpoint` — invoke URL for the API Gateway
- `sns_topic_arn` — ARN of the alert SNS topic
- `chime_sdk_role_arn` — ARN of the Chime SDK IAM role

## Prerequisites

- Terraform >= 1.x
- AWS credentials with permissions for IAM, SNS, CloudWatch, and API Gateway

## Deployment

```bash
terraform init
terraform plan
terraform apply
```

## Notes

- The IAM policy uses `chime:*`. Replace with the specific actions actually needed before production use.
- `unauthorized_access_alarm` watches the API Gateway `4XXError` metric, which counts all 4xx responses (not only 401/403). The alarm name is descriptive, not metric-accurate. Rename or refine the metric filter if true unauthorized-access detection is required.
- The Chime API rate metric used by `usage_limit_alarm` should be verified against the current Amazon Chime SDK CloudWatch metric list before relying on it. Metric names in the `AWS/Chime` namespace have changed over time.
- The HTTP API is provisioned without routes or integrations. Add `aws_apigatewayv2_route` and `aws_apigatewayv2_integration` resources before the API can serve traffic.
- The default region is `us-east-1`. Override via the AWS provider block or environment variable.
