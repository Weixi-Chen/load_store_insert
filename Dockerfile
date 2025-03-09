# Use an Ubuntu base image
FROM ubuntu:latest

# Set non-interactive mode to avoid prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# Update package lists and install dependencies
RUN apt update && apt install -y \
    g++ \
    cmake \
    llvm \
    clang \
    llvm-dev \
    libllvm19 \
    build-essential \
    python3-pip \
    python3-venv \
    && rm -rf /var/lib/apt/lists/*

# Create a working directory inside the container
WORKDIR /app

# Link the working repo to virtual environment
VOLUME ["/app"]
WORKDIR /app

# Set default command to bash (so you can interact with the container)
CMD ["/bin/bash"]