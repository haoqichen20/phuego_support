# Start with a base image that includes Python.
FROM python:3.11-slim

# Set the working directory in the container
WORKDIR /app

# Install Java, wget, and clean up the package lists to reduce image size
RUN apt-get update && \
    apt-get install -y openjdk-17-jre-headless wget && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Copy the Java program and any required files into the container.
COPY sml-toolkit-0.9.4c.jar /app/sml-toolkit-0.9.4c.jar
# If you have additional files or directories to copy, use COPY commands here.

# Copy the requirements.txt file and install Python dependencies.
COPY requirements.txt /app/requirements.txt
RUN pip install --no-cache-dir -r requirements.txt
