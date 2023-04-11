# Python Application with Redis
FROM python:3.11

# Set the working directory to /app
WORKDIR /app

# Copy the script files, requirements file, and environment file
COPY scripts/ /app
COPY requirements.txt /app
COPY .env /app

# Install the required dependencies
RUN pip install --no-cache-dir -r requirements.txt

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
RUN pip install PyGObject

# Copy the config file
COPY config.yaml /app

# Python script to run when the container launches
CMD ["python", "main.py"]
