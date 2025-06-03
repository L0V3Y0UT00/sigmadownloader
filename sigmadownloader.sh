#!/bin/bash

# Check if Python is installed
if ! command -v python3 &> /dev/null; then
    echo "Python3 is required but not found. Please install Python3."
    exit 1
fi

# Check if URL is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <video_url>"
    exit 1
fi

# Run the Python script with the provided URL
python3 download_media.py "$1"

if [ $? -eq 0 ]; then
    echo "Operation completed successfully!"
else
    echo "Operation failed. Check the URL or your internet connection."
    exit 1
fi