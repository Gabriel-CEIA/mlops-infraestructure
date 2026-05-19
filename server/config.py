from pathlib import Path

BASE_DIR = Path("./models").resolve()

S3_BUCKET = "ml-model-storage-s3-bucket-12345"
S3_PREFIX = "/"
SQS_QUEUE_URL = "https://sqs.us-east-2.amazonaws.com/563227989034/PullReleaseQueue"
AWS_REGION = "us-east-2"
