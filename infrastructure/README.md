# Terraform Configuration for AWS API Gateway with WebSocket and Lambda

This Terraform configuration sets up an AWS API Gateway with WebSocket support and integrates it with an AWS Lambda function. The Lambda function echoes back the received payload. CloudWatch logging is enabled for monitoring and debugging purposes.

## Prerequisites

- Terraform installed on your local machine.
- AWS CLI configured with appropriate permissions.
- An AWS account with the necessary permissions to create IAM roles, Lambda functions, API Gateway, and CloudWatch log groups.

## Configuration Details

### Resources Created

1. **IAM Roles and Policies**
   - `aws_iam_role.lambda_exec_role`: IAM role for Lambda execution.
   - `aws_iam_role_policy.lambda_exec_policy`: Policy for Lambda execution role.
   - `aws_iam_role.apigw_cloudwatch_role`: IAM role for API Gateway CloudWatch logging.
   - `aws_iam_role_policy.apigw_cloudwatch_role_policy`: Policy for API Gateway CloudWatch logging role.

2. **Lambda Function**
   - `aws_lambda_function.echo_function`: Lambda function that echoes back the received payload.

3. **API Gateway**
   - `aws_apigatewayv2_api.api_gateway`: WebSocket API Gateway.
   - `aws_apigatewayv2_integration.lambda_integration`: Integration of API Gateway with Lambda.
   - `aws_apigatewayv2_route.default_route`: Default route for the WebSocket API.
   - `aws_apigatewayv2_route_response.default_route_response`: Default route response.
   - `aws_apigatewayv2_stage.test_stage`: Stage for the WebSocket API.

4. **CloudWatch**
   - `aws_cloudwatch_log_group.api_gw_log_group`: Log group for API Gateway logs.

## Usage

### Step 1: Clone the Repository

```sh
git clone https://github.com/jsambuo/pomodoro-app.git
cd infrastructure
```

### Step 2: Initialize Terraform

Initialize the Terraform configuration by running the following command:

```sh
terraform init
```

### Step 3: Apply the Terraform Configuration

Apply the Terraform configuration to create the resources:

```sh
terraform apply
```

You will be prompted to confirm the apply. Type `yes` to proceed.

### Step 4: Test the WebSocket API

Once the resources are created, you can test the WebSocket API using `wscat`. Install `wscat` if you haven't already:

```sh
npm install -g wscat
```

Connect to the WebSocket API using the URL output by Terraform:

```sh
wscat -c wss://<api-id>.execute-api.<region>.amazonaws.com/test
```

Send a test message:

```sh
> hello world
```

### Outputs

- `url`: The invoke URL for the WebSocket API.

## Cleanup

To delete all resources created by this Terraform configuration, run:

```sh
terraform destroy
```

You will be prompted to confirm the destroy. Type `yes` to proceed.

## Note on WebSocket Issue

There is a known issue where the WebSocket API Gateway won't function correctly until you manually edit and save the integration settings for the `$default` route. To resolve this issue, follow these steps:

1. Go to the AWS Management Console.
2. Navigate to **API Gateway**.
3. Select your WebSocket API (`EchoWebSocketAPI`).
4. Go to **Routes**.
5. Select the `$default` route.
6. Go to **Request Integration**.
7. Click **Edit** and then **Save** without making any changes.

You need to perform this manual step once to make the WebSocket work properly.

## License

This project is licensed under the MIT License.

## Acknowledgements

- [Terraform](https://www.terraform.io/)
- [AWS](https://aws.amazon.com/)
