FROM python:3.12-slim

# Working directory inside the container
WORKDIR /app

# Copy dependency file first
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy project files
COPY . .

# Flask application listens on port 5000
EXPOSE 5000

# Start the application
CMD ["python", "app.py"]