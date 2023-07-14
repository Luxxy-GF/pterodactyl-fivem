FROM debian:bookworm-slim

# Path: Dockerfile

RUN apt-get update && apt upgrade -y && apt-get install -y \
    build-essential \
    curl \
    git \
    libssl-dev \
    pkg-config \
    tar \
    jq \
    && rm -rf /var/lib/apt/lists/*


RUN adduser -D -h /home/container container

USER        container
ENV         USER=container HOME=/home/container
WORKDIR     /home/container

COPY        ./entrypoint.sh /entrypoint.sh
COPY       ./start.sh /start.sh
CMD         [ "/bin/bash", "/entrypoint.sh" ]
