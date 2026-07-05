FROM ubuntu:jammy-20260627

# Avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies: QEMU and the Docker client (linux-image-generic is large)
RUN apt-get update && apt-get install -y --no-install-recommends \
    qemu-system-x86 \
    qemu-utils \
    docker.io \
    libguestfs-tools \
    ca-certificates \
    linux-image-generic \
    curl \
    sshpass \ 
    && rm -rf /var/lib/apt/lists/* 

WORKDIR /workspace

