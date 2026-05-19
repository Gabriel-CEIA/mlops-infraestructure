import json
import boto3
from config import SQS_QUEUE_URL, AWS_REGION
from s3_sync import download_file, delete_file

sqs = boto3.client("sqs", region_name=AWS_REGION)


def process_message(msg):
    body = json.loads(msg["Body"])

    # S3 events may be wrapped (SNS → SQS)
    if "Message" in body:
        body = json.loads(body["Message"])

    for record in body["Records"]:
        event = record["eventName"]
        key = record["s3"]["object"]["key"]

        if event.startswith("ObjectCreated"):
            download_file(key)

        elif event.startswith("ObjectRemoved"):
            delete_file(key)


def run_worker():
    while True:
        resp = sqs.receive_message(
            QueueUrl=SQS_QUEUE_URL,
            MaxNumberOfMessages=10,
            WaitTimeSeconds=20,
        )

        for msg in resp.get("Messages", []):
            try:
                process_message(msg)

                sqs.delete_message(
                    QueueUrl=SQS_QUEUE_URL,
                    ReceiptHandle=msg["ReceiptHandle"],
                )
            except Exception as e:
                print("Error:", e)

if __name__ == "__main__":
    run_worker()
