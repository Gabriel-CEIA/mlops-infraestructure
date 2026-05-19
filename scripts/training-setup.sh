#!/bin/bash
        wget https://amazoncloudwatch-agent.s3.amazonaws.com/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb
        sudo dpkg -i -E ./amazon-cloudwatch-agent.deb

        cat << EOF > /opt/aws/amazon-cloudwatch-agent/bin/config.json
{{
  "logs": {{
    "logs_collected": {{
      "files": {{
        "collect_list": [
          {{
            "file_path": "/var/log/messages",
            "log_group_name": "/ec2/training-instance",
            "log_stream_name": "{event.get('project_id')}",
            "timestamp_format": "%b %d %H:%M:%S"
          }},
          {{
            "file_path": "/var/log/cloud-init.log",
            "log_group_name": "/ec2/user-data",
            "log_stream_name": "{event.get('project_id')}"
          }}
        ]
      }}
    }}
  }}
}}
EOF

        /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
            -a fetch-config \
            -m ec2 \
            -c file:/opt/aws/amazon-cloudwatch-agent/bin/config.json \
            -s

        apt update
        apt install docker.io -y
        snap aws-cli --classic
        aws ecr get-login-password --region us-east-2 | \
        docker login --username AWS --password-stdin {ecr_repo_url}

        docker pull {ecr_repo_url}:latest

        docker run \
        -e MLFLOW_TRACKING_URI={os.getenv('MLFLOW_TRACKING_URI')} \
        -e DATA_BUCKET_NAME={os.getenv('DATA_BUCKET_NAME')} \
        {ecr_repo_url}:latest \
        python train.py
