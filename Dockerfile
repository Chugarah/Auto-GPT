# 'dev' or 'release' container build
ARG BUILD_TYPE=dev

# Use an official Python base image from the Docker Hub
FROM python:3.10-slim AS autogpt-base

# Install browsers
RUN apt-get update && apt-get install -y \
    chromium-driver firefox-esr \
    ca-certificates

# Install utilities
RUN apt-get install -y curl jq wget git

# Set environment variables
ENV PIP_NO_CACHE_DIR=yes \
    PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1


# Install required packages
RUN apt-get update && \
    apt-get install -y redis-server \
    pkg-config \
    libcairo2-dev \
    gcc \
    python3-dev \
    libgirepository1.0-dev \
    libgstreamer1.0-dev \
    pulseaudio && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install PyGObject using pip
RUN pip install PyGObject pymilvus
RUN pip install --upgrade pip

# Install the required python packages globally
ENV PATH="$PATH:/root/.local/bin"
COPY requirements.txt .

# Set the entrypoint
ENTRYPOINT ["python", "-m", "autogpt"]

# dev build -> include everything
FROM autogpt-base as autogpt-dev
RUN pip install --no-cache-dir -r requirements.txt

# FOR Debugging Python
RUN apt-get update && apt-get install -y python3 python3-pip && pip3 install flask

WORKDIR /app
ONBUILD COPY . ./

# release build -> include bare minimum
FROM autogpt-base as autogpt-release
RUN sed -i '/Items below this point will not be included in the Docker Image/,$d' requirements.txt && \
    pip install --no-cache-dir -r requirements.txt
WORKDIR /app
ONBUILD COPY autogpt/ ./autogpt

FROM autogpt-${BUILD_TYPE} AS auto-gpt
