#!/bin/bash

# ---------------------------------------------
# cleanup.sh
# ---------------------------------------------
# This script cleans up all AWS resources
# created by the Telemax real-time data pipeline.
#
# Resources removed:
# - CloudFormation stack (which deletes Kinesis,
#   Lambda, DynamoDB, IAM role, etc.)
#
# Prerequisites:
# - AWS CLI configured (aws configure)
# - Script executed from project root directory
# ---------------------------------------------

# Exit immediately if any command fails
set -e

echo "Starting cleanup of Telemax real-time data pipeline..."

# ---------------------------------------------
# Step 1: Delete CloudFormation stack
# ---------------------------------------------
echo "Deleting CloudFormation stack..."
aws cloudformation delete-stack \
  --stack-name telemax-realtime-stack

echo "Waiting for stack deletion to complete..."
aws cloudformation wait stack-delete-complete \
  --stack-name telemax-realtime-stack

echo "Cleanup completed successfully."
