# Use the official Jenkins agent image as the base image
FROM hub.docker.zlabi.dev/jenkins/agent:3283.v92c105e0f819-1-alpine-jdk21

# Switch to root user to install dependencies
USER root

# Update packages
RUN apk update

# Install Docker CLI
RUN apk add --no-cache docker-cli=26.1.5-r0

# Install Docker Compose V2 plugin
RUN apk add --no-cache docker-cli-compose

# Install Python3 and pip
ENV PYTHONUNBUFFERED=1
RUN apk add --no-cache python3=3.12.9-r0 pipx=1.6.0-r0

# Install Node.js and npm
RUN apk add --no-cache nodejs=20.19.5 npm=10.9.1-r0

# Download and install Taskfile (task)
RUN wget -O /tmp/task_linux_amd64.tar.gz https://github.com/go-task/task/releases/download/v3.24.0/task_linux_amd64.tar.gz && \
    tar -xzf /tmp/task_linux_amd64.tar.gz -C /tmp && \
    mv /tmp/task /usr/local/bin/task && \
    chmod +x /usr/local/bin/task && \
    rm /tmp/task_linux_amd64.tar.gz

# Create a writable temp directory
RUN mkdir -p /home/jenkins/tmp && chmod 777 /home/jenkins/tmp

# Switch back to jenkins user
USER jenkins

# Set TMPDIR to the writable temp directory
ENV TMPDIR=/home/jenkins/tmp

# Default command to keep the container running
CMD ["/bin/sh"]
