# Use lightweight Python image
FROM python:3.12-slim

# Set workdir
WORKDIR /app

# Install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy app code
COPY app .

# Run the app
CMD ["python", "/app/run.py"]