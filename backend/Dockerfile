FROM python:3.9-slim

WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements first for better caching
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application
COPY . .

# Create necessary directories
RUN mkdir -p uploads saved_models bg

# Download the model
RUN python download_model.py

# Set environment variables
ENV DEBUG=False
ENV PORT=5000
ENV UPLOAD_FOLDER=uploads
ENV BG_FOLDER=bg
ENV MODEL_DIR=saved_models

# Expose the port
EXPOSE 5000

# Run the application
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"] 