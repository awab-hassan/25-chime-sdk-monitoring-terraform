provider "aws" {
  region = "xx-region-1" # set AWS region
}

# IAM Role for Chime with permissions
resource "aws_iam_role" "chime_role" {
  name = "chime-dev-role"  # Name of the IAM role for Chime
  assume_role_policy = jsonencode({  # Policy to allow Chime to assume this role
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",  # Granting permission to assume role
        "Principal": {
          "Service": "chime.amazonaws.com"  # Specifies Chime as the trusted service
        },
        "Action": "sts:AssumeRole"  # Allows Chime to assume this role
      }
    ]
  })
}

# IAM Policy for Chime with necessary permissions
resource "aws_iam_policy" "chime_policy" {
  name        = "chime-dev-policy"  # Name of the IAM policy for Chime
  description = "Policy to allow comprehensive Amazon Chime access"  # Description for the policy
  policy      = jsonencode({  # JSON encoding of permissions
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",  # Allows access to specified actions
        "Action": [
          # Meeting Management Permissions
          "chime:CreateMeeting",
          "chime:DeleteMeeting",
          "chime:GetMeeting",
          "chime:ListMeetings",
          "chime:UpdateMeeting",
          "chime:CreateAttendee",
          "chime:DeleteAttendee",
          "chime:GetAttendee",
          "chime:ListAttendees",
          
          # Messaging Permissions (for chat functionality)
          "chime:CreateChannel",
          "chime:DeleteChannel",
          "chime:GetChannel",
          "chime:ListChannels",
          "chime:UpdateChannel",
          "chime:SendChannelMessage",
          "chime:ListChannelMessages",
          
          # Phone Number Management Permissions
          "chime:SearchAvailablePhoneNumbers",
          "chime:AssociatePhoneNumbersWithVoiceConnector",
          "chime:DeletePhoneNumber",
          "chime:GetPhoneNumber",
          "chime:ListPhoneNumbers",
          "chime:UpdatePhoneNumber",

          # User and Account Management Permissions
          "chime:CreateUser",
          "chime:DeleteUser",
          "chime:ListUsers",
          "chime:UpdateUser",
          "chime:GetAccount",
          "chime:ListAccounts",
          "chime:UpdateAccount",

          # Voice Connectors and SIP Media Applications Permissions
          "chime:CreateVoiceConnector",
          "chime:DeleteVoiceConnector",
          "chime:GetVoiceConnector",
          "chime:UpdateVoiceConnector",
          "chime:CreateSipMediaApplication",
          "chime:GetSipMediaApplication",
          "chime:UpdateSipMediaApplication",
          
          # Other Chime Services Permissions
          "chime:TagResource",
          "chime:UntagResource",
          "chime:ListTagsForResource",

          # App Instance Management Permissions
          "chime:CreateAppInstance",
          "chime:GetAppInstance",
          "chime:DeleteAppInstance",
          
          # App Instance User Management Permissions
          "chime:CreateAppInstanceUser",
          "chime:DescribeAppInstanceUser",
          "chime:DeleteAppInstanceUser"
        ],
        "Resource": "*"  # Grants permissions on all resources for specified actions
      }
    ]
  })
}

# Attach IAM Policy to Role
resource "aws_iam_role_policy_attachment" "chime_policy_attach" {
  role       = aws_iam_role.chime_role.name  # Associates policy with the chime_role
  policy_arn = aws_iam_policy.chime_policy.arn  # ARN of the policy to attach to the role
}

resource "aws_chimesdkidentity_app_instance" "chime_instance" {
  name = "chime-dev"
}

# Output the ARN for the IAM Role
output "chime_role_arn" {
  value       = aws_iam_role.chime_role.arn  # Outputs the ARN of the IAM role for reference
  description = "The ARN of the IAM Role for Amazon Chime"  # Description for the output
}

# Output the ARN of the App Instance
output "chime_app_instance_arn" {
  value       = aws_chimesdkidentity_app_instance.chime_instance.arn
  description = "The ARN of the newly created Chime App Instance"
}