# 🚀 AWS Real-Time Data Pipeline

A simple **near real-time, event-driven data pipeline** built on AWS using **Amazon Kinesis**, **AWS Lambda**, and **Amazon DynamoDB**.

The project demonstrates how streaming data from a simulated device can be ingested, processed immediately, and stored using a fully serverless architecture.

---

## 📌 Overview

This project implements a real-time data pipeline where:

- A simulated **device (producer)** sends data into Amazon Kinesis
- AWS Lambda processes streaming records as they arrive
- Amazon DynamoDB stores the processed data
- Infrastructure is provisioned using AWS CloudFormation
- Execution and cleanup are automated using shell scripts

The design is intentionally kept simple and aligned with AWS documentation and best practices.


---

## ⚙️ AWS Services Used

- **Amazon Kinesis Data Streams** – real-time data ingestion
- **AWS Lambda** – serverless stream processing
- **Amazon DynamoDB** – NoSQL data storage
- **AWS CloudFormation** – infrastructure provisioning

---

## 🚀 Running the Pipeline

The entire pipeline is executed using a single shell script.

### Steps:
1. Configure AWS credentials using the AWS CLI
2. Navigate to the project root directory
3. Execute the pipeline script

The `run_pipeline.sh` script:
- Creates the CloudFormation stack
- Uploads the Lambda function code
- Runs the simulated producer
- Allows data to flow through the pipeline automatically

No manual interaction with AWS services is required after running the script.

---

## 🔍 Verifying the Pipeline

After the pipeline runs, data can be verified by scanning the DynamoDB table.  
Records should appear shortly after the producer sends data to the stream.

---

## 🧪 Producer as a Device

The producer script acts as a **simulated edge device**, generating real-time telemetry such as:
- Device identifier
- Timestamp
- Sample metrics

This approach is commonly used in labs and early-stage system design before integrating physical devices.

---

## 🧹 Cleanup

All AWS resources created by the project can be removed using the cleanup script.

The `cleanup.sh` script deletes the CloudFormation stack, ensuring that no resources are left running.

---

## ⏱️ Is This Real-Time?

Yes.

- Data is processed immediately as it enters the Kinesis stream
- No batch processing or scheduled ETL jobs
- Fully event-driven architecture

This aligns with AWS’s definition of **near real-time streaming pipelines**.

---

## 📄 Notes

- The project focuses on clarity and correctness rather than complexity
- Designed for learning, labs, and demonstrations
- Can be extended with additional AWS services if required

---

✨ *A clean and practical example of a real-time serverless data pipeline on AWS.*
