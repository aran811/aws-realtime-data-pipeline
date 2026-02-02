#!/bin/bash

# ---------------------------------------------
# run_pipeline.sh
# ---------------------------------------------
# This script deploys and runs the Telemax
# real-time data pipeline end-to-end.
#
# Steps performed:
# 1. Create the CloudFormation stack
# 2. Upload Lambda function code
# 3. Ensure required Python dependency is available
# 4. Run the simulated device (producer)
# 5. Scan DynamoDB to verify data ingestion
#
# Prerequisites:
# - AWS CLI configured (aws configure)
# - Python installed
# - Script executed from project root directory
# ---------------------------------------------

# Exit immediately if any command fails
set -e

echo "Starting Telemax real-time data pipeline..."

# ---------------------------------------------
# Step 1: Create CloudFormation stack
# ---------------------------------------------
echo "Deploying CloudFormation stack..."
cd cloudformation
aws cloudformation create-stack \
  --stack-name telemax-realtime-stack \
  --template-body file://telemax-stack.yaml \
  --capabilities CAPABILITY_NAMED_IAM
cd ..

# ---------------------------------------------
# Step 2: Upload Lambda function code
# ---------------------------------------------
echo "Uploading Lambda function code..."
aws lambda update-function-code \
  --function-name TelemaxKinesisProcessor \
  --zip-file fileb://lambda/function.zip

# ---------------------------------------------
# Step 3: Install required Python dependency
# ---------------------------------------------
echo "Installing Python dependency (boto3)..."
pip install boto3

# ---------------------------------------------
# Step 4: Run the simulated device / producer
# ---------------------------------------------
echo "Running Kinesis producer (simulated device)..."
python producer/kinesis_producer.py

# ---------------------------------------------
# Step 5: Verify data in DynamoDB
# ---------------------------------------------
echo "Scanning DynamoDB table for ingested data..."
aws dynamodb scan --table-name TelemaxData

echo "Pipeline execution completed."


