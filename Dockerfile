FROM debian:bookworm-slim

LABEL org.opencontainers.image.source https://github.com/Luxxy-GF/pterodactyl-fivem

RUN apt-get update && apt upgrade -y && apt-get install -y \
    build-essential \
    curl \
    git \
    libssl-dev \
    pkg-config \
    tar \
    jq \
    procps \
    liblua5.3-0 \
    libz-dev \
    tzdata \
    && rm -rf /var/lib/apt/lists/*


RUN useradd -m -d /app/data container

USER        container
ENV         USER=container HOME=/app/data
WORKDIR     /app/data

COPY        ./entrypoint.sh /entrypoint.sh
COPY        --chmod=777 ./start.sh /start.sh
CMD         [ "/bin/bash", "/entrypoint.sh" ]
