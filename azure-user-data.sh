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

EOM

# Register gitlab runner
gitlab-runner register --non-interactive \
                       --name "gitlabrunner" \
                       --url "https://gitlab.com" \
                       --registration-token "11111" \
                       --executor docker \
                       --docker-image "ruby:latest"

# Start services
service docker start
service gitlab-runner start
