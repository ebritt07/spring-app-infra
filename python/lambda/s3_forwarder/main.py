import json
import boto3
import os
TARGET_BUCKET_NAME = os.getenv('TARGET_BUCKET_NAME', 'default-target-bucket')

def handler(event, context):
    print("Received event:")
    print(json.dumps(event, indent=2))
    
    s3 = boto3.client('s3')
    for record in event.get('Records', []):
        bucket_name = record['s3']['bucket']['name']
        object_key = record['s3']['object']['key']
        try:
            copy_source = {'Bucket': bucket_name, 'Key': object_key}
            s3.copy_object(
                CopySource=copy_source,
                Bucket=TARGET_BUCKET_NAME,
                Key=object_key
            )
            print(f"Forwarded {object_key} from {bucket_name} to {TARGET_BUCKET_NAME}")
        except Exception as e:
            print(f"Error forwarding {object_key}: {e}")
    return {
        'statusCode': 200,
        'body': json.dumps('S3 event forwarded successfully')
    }
    