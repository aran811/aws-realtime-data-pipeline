import json
import base64
import boto3

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('TelemaxData')

def lambda_handler(event, context):
    for record in event['Records']:
        payload = base64.b64decode(record['kinesis']['data']).decode('utf-8')
        data = json.loads(payload)

        table.put_item(
            Item={
                'device_id': data['deviceId'],
                'timestamp': data['timestamp'],
                'signalStrength': data['signalStrength']
            }
        )

    return {"statusCode": 200}





