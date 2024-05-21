resource "aws_cognito_user_pool" "user_pool" {
  name = "my_user_pool"

  password_policy {
    minimum_length    = 8
    require_lowercase = true
    require_numbers   = true
    require_symbols   = true
    require_uppercase = true
    temporary_password_validity_days = 7
  }

  auto_verified_attributes = ["email"]

  schema {
    attribute_data_type = "String"
    name                = "email"
    required            = true
    mutable             = true
    string_attribute_constraints {
      min_length = 5
      max_length = 50
    }
  }

  admin_create_user_config {
    allow_admin_create_user_only = false
  }

  verification_message_template {
    default_email_option = "CONFIRM_WITH_LINK"
  }

  tags = {
    Environment = "dev"
  }
}

resource "aws_cognito_user_pool_client" "user_pool_client" {
  name            = "my_user_pool_client"
  user_pool_id    = aws_cognito_user_pool.user_pool.id
  generate_secret = false

  allowed_oauth_flows = ["code", "implicit"]

  allowed_oauth_flows_user_pool_client = true

  explicit_auth_flows = [
    "ALLOW_USER_SRP_AUTH",
    "ALLOW_REFRESH_TOKEN_AUTH",
    "ALLOW_CUSTOM_AUTH",
    "ALLOW_USER_PASSWORD_AUTH",
  ]

  supported_identity_providers = ["COGNITO"]

  callback_urls = ["yourapp://callback"]  # Change to your app's callback URL
  logout_urls   = ["yourapp://signout"]   # Change to your app's signout URL

  allowed_oauth_scopes = [
    "phone",
    "email",
    "openid",
    "profile",
    "aws.cognito.signin.user.admin",
  ]

  depends_on = [aws_cognito_user_pool.user_pool]
}

resource "aws_cognito_identity_pool" "identity_pool" {
  identity_pool_name               = "my_identity_pool"
  allow_unauthenticated_identities = false

  cognito_identity_providers {
    client_id    = aws_cognito_user_pool_client.user_pool_client.id
    provider_name = aws_cognito_user_pool.user_pool.endpoint
  }
}

resource "aws_iam_role" "cognito_auth_role" {
  name = "Cognito_Auth_Role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Federated = "cognito-identity.amazonaws.com"
        },
        Action = "sts:AssumeRoleWithWebIdentity",
        Condition = {
          "StringEquals": {
            "cognito-identity.amazonaws.com:aud": aws_cognito_identity_pool.identity_pool.id
          },
          "ForAnyValue:StringLike": {
            "cognito-identity.amazonaws.com:amr": "authenticated"
          }
        }
      }
    ]
  })

  inline_policy {
    name   = "cognito_auth_policy"
    policy = jsonencode({
      Version = "2012-10-17",
      Statement = [
        {
          Effect = "Allow",
          Action = [
            "mobileanalytics:PutEvents",
            "cognito-sync:*",
            "cognito-identity:*"
          ],
          Resource = "*"
        }
      ]
    })
  }
}

resource "aws_iam_role" "cognito_unauth_role" {
  name = "Cognito_Unauth_Role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Federated = "cognito-identity.amazonaws.com"
        },
        Action = "sts:AssumeRoleWithWebIdentity",
        Condition = {
          "StringEquals": {
            "cognito-identity.amazonaws.com:aud": aws_cognito_identity_pool.identity_pool.id
          },
          "ForAnyValue:StringLike": {
            "cognito-identity.amazonaws.com:amr": "unauthenticated"
          }
        }
      }
    ]
  })

  inline_policy {
    name   = "cognito_unauth_policy"
    policy = jsonencode({
      Version = "2012-10-17",
      Statement = [
        {
          Effect = "Allow",
          Action = [
            "mobileanalytics:PutEvents",
            "cognito-sync:*"
          ],
          Resource = "*"
        }
      ]
    })
  }
}

resource "aws_cognito_identity_pool_roles_attachment" "identity_pool_roles" {
  identity_pool_id = aws_cognito_identity_pool.identity_pool.id

  roles = {
    "authenticated"   = aws_iam_role.cognito_auth_role.arn
    "unauthenticated" = aws_iam_role.cognito_unauth_role.arn
  }
}

resource "aws_cognito_user_pool_domain" "user_pool_domain" {
  domain        = "sambuo-user-pool-domain"  # Change this to your preferred domain name
  user_pool_id  = aws_cognito_user_pool.user_pool.id
}
