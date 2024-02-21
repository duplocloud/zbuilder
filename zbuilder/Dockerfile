# Use Ubuntu 22.04 as base image
FROM ubuntu:latest

# Install necessary packages
RUN apt-get update && \
    apt-get install -y python3 python3-pip supervisor \
                       apt-transport-https ca-certificates curl unzip \
					   lsof gawk \
                       gnupg lsb-release && \
    rm -rf /var/lib/apt/lists/*

# Add Docker's official GPG key
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -

# Set up Docker repository
RUN echo "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
    > /etc/apt/sources.list.d/docker.list

# Install Docker CE
RUN apt-get update && \
    apt-get install -y docker-ce docker-ce-cli containerd.io && \
    rm -rf /var/lib/apt/lists/*

# Install AWS CLI
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip
RUN ./aws/install
RUN aws --version

# Display installed versions
RUN python3 --version && \
    aws --version && \
    docker --version

RUN pip install requests logger
RUN pip install boto3

COPY zbuild.sh /zbuild.sh
COPY zbuildmonitor.py /zbuildmonitor.py

# set up supervisord
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ENTRYPOINT ["/bin/bash", "-c", "/usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf -n"]