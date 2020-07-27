#!/bin/bash

# Update system
yum update -y && \

# Install htop and docker
yum install -y htop docker && \

# Install Gitlab CI Multi Runner
curl -L https://packages.gitlab.com/install/repositories/runner/gitlab-ci-multi-runner/script.rpm.sh | bash && \
yum install -y gitlab-ci-multi-runner

# Enable Services at startup
sudo chkconfig docker on
sudo chkconfig gitlab-runner on

# Add gitlab-runner config
mkdir -p /etc/gitlab-runner
cat > /etc/gitlab-runner/config.toml <<- EOM
[[runners]]
  limit = 10
  # (...)
  executor = "docker+machine"
  [runners.machine]
    IdleCount = 2
    IdleTime = 1800
    # (...)

EOM

# Register gitlab runner
gitlab-runner register --non-interactive \
                       --name "gitlab-vm" \
                       --url "https://gitlab.corum.sh" \
                       --registration-token "Qsc1sPfjb6X8f9GZcDaC" \
                       --executor docker \
                       --docker-image "alpine:latest"

# Start services
service docker start
service gitlab-runner start
