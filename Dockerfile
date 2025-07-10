# Use Python 3.10 slim base image
FROM python:3.10-slim

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Create and set working directory
WORKDIR /app

# Install system dependencies from apt.txt and packages.txt
COPY apt.txt packages.txt ./

RUN apt-get update && \
    xargs -r -a apt.txt apt-get install -y && \
    xargs -r -a packages.txt apt-get install -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Python dependencies
COPY requirements.txt ./
RUN pip install --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# Copy app source code
COPY . .

# Expose Streamlit's default port
EXPOSE 8501

# Run Streamlit app
CMD ["streamlit", "run", "app_stream.py", "--server.port=8501", "--server.address=0.0.0.0"]
