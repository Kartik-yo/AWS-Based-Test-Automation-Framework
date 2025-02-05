# AWS-Based-Test-Automation-Framework

## Overview
This project automates UI and API testing using PyTest and Selenium, integrated with AWS services. 

## Features
- **AWS Lambda** for serverless test execution
- **Terraform** for infrastructure as code
- **S3 Bucket** for storing test reports
- **CloudWatch Logs** for monitoring
- **GitHub Actions** for CI/CD automation

## Setup
### Prerequisites
- Terraform installed
- AWS CLI configured with access keys
- Python 3.9 installed

### Steps to Deploy
1. **Initialize Terraform:**
   ```sh
   cd infrastructure
   terraform init
   ```
2. **Apply Terraform Configuration:**
   ```sh
   terraform apply -auto-approve
   ```
3. **Deploy Lambda Function:**
   ```sh
   cd lambda
   zip -r lambda_test_runner.zip lambda_function.py
   aws lambda update-function-code --function-name AWS_Test_Automation --zip-file fileb://lambda_test_runner.zip
   ```
4. **Run Tests:**
   ```sh
   pytest tests/
   ```

## CI/CD Pipeline
- **Trigger:** Push to GitHub runs automated tests
- **Artifacts:** Test reports uploaded to S3
- **Notifications:** Alerts via AWS SNS (optional)
