resource "aws_sqs_queue" "pull_release_queue" {
  name = "PullReleaseQueue"
}

resource "aws_sqs_queue_policy" "pull_release_policy" {
  queue_url = aws_sqs_queue.pull_release_queue.id
  policy    = data.aws_iam_policy_document.pull_release_policy_document.json
}
