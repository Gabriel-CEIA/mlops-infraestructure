import boto3
from pathlib import Path
from config import BASE_DIR, S3_BUCKET

s3 = boto3.client("s3")

def ensure_parent(path: Path):
    path.parent.mkdir(parents=True, exist_ok=True)


def download_file(key: str):
    local_path = BASE_DIR / key
    ensure_parent(local_path)

    s3.download_file(S3_BUCKET, key, str(local_path))


def delete_file(key: str):
    local_path = BASE_DIR / key
    if local_path.exists():
        local_path.unlink()
