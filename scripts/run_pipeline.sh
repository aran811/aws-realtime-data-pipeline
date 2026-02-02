#!/bin/bash

# ---------------------------------------------
# run_pipeline.sh
# ---------------------------------------------
# Deploys and runs the Telemax real-time data pipeline
# with proper sequencing and safety checks.
# ---------------------------------------------

set -e

STACK_NAME="telemax-realtime-stack"
TEMPLATE_PATH="cloudformation/telemax-stack.yaml"
LAMBDA_FUNCTION_NAME="TelemaxKinesisProcessor"
LAMBDA_ZIP_PATH="lambda/function.zip"
DYNAMO_TABLE_NAME="TelemaxData"

echo "🚀 Starting Telemax real-time data pipeline..."

# ---------------------------------------------
# Step 1: Create CloudFormation stack
# ---------------------------------------------
echo "📦 Deploying CloudFormation stack..."

aws cloudformation create-stack \
  --stack-name "$STACK_NAME" \
  --template-body "file://$TEMPLATE_PATH" \
  --capabilities CAPABILITY_NAMED_IAM || \
echo "⚠️ Stack already exists, continuing..."

echo "⏳ Waiting for CloudFormation stack to be CREATE_COMPLETE..."
aws cloudformation wait stack-create-complete \
  --stack-name "$STACK_NAME"

echo "✅ CloudFormation stack is ready."

# ---------------------------------------------
# Step 2: Upload Lambda function code
# ---------------------------------------------
echo "🧩 Uploading Lambda function code..."
aws lambda update-function-code \
  --function-name "$LAMBDA_FUNCTION_NAME" \
  --zip-file "fileb://$LAMBDA_ZIP_PATH"

echo "✅ Lambda code uploaded."

# ---------------------------------------------
# Step 3: Check & install boto3 if needed
# ---------------------------------------------
echo "🔍 Checking for boto3..."

if python -c "import boto3" &> /dev/null; then
  echo "✅ boto3 is already installed."
else
  echo "📥 boto3 not found. Installing..."
  pip install boto3
  echo "✅ boto3 installed."
fi

# ---------------------------------------------
# Step 4: Run the simulated device / producer
# ---------------------------------------------
echo "📡 Running Kinesis producer (simulated device)..."
python producer/kinesis_producer.py

# ---------------------------------------------
# Step 5: Verify data in DynamoDB
# ---------------------------------------------
echo "🗄️ Scanning DynamoDB table for ingested data..."
aws dynamodb scan --table-name "$DYNAMO_TABLE_NAME"

echo "🎉 Pipeline execution completed successfully."
