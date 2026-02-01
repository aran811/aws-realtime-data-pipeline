import boto3
import json
import time
from datetime import datetime

kinesis = boto3.client('kinesis', region_name='us-east-1')
STREAM_NAME = 'TelemaxStream'

def send_record():
    data = {
        "deviceId": "TX-101",
        "signalStrength": "Strong",
        "timestamp": datetime.utcnow().isoformat()
    }

    kinesis.put_record(
        StreamName=STREAM_NAME,
        Data=json.dumps(data),
        PartitionKey="device-1"
    )

    print("Record sent")

if __name__ == "__main__":
    for _ in range(10):        # sends 10 records automatically
        send_record()
        time.sleep(2)

    print("Automation complete")