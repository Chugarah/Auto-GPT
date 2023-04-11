# Python Application with Redis
FROM python:3.11

# Install Redis
RUN apt-get update && apt-get install -y redis-server

# Set the working directory to /app
WORKDIR /app

# Copy the script files, requirements file, and environment file
COPY scripts/ /app
COPY requirements.txt /app
COPY .env /app

# Install the required dependencies
RUN pip install --no-cache-dir -r requirements.txt

COPY config.yaml /app

# Python script to run when the container launches
CMD ["python", "main.py"]
