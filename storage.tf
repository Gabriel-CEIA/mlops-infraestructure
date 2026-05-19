

resource "aws_s3_bucket" "data_storage" {
  bucket = "ml-data-storage-s3-bucket-12345"
}

resource "aws_s3_bucket" "artifact_storage" {
  bucket = "ml-artifact-storage-s3-bucket-12345"
}

resource "aws_s3_bucket" "model_storage" {
  bucket = "ml-model-storage-s3-bucket-12345"
}

resource "aws_s3_bucket_notification" "model_upload_event" {
  bucket = aws_s3_bucket.model_storage.id
  queue {
    queue_arn = aws_sqs_queue.pull_release_queue.arn
    events    = ["s3:ObjectCreated:*"]
  }
}
