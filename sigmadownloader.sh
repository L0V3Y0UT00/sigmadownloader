#!/bin/bash

# Check if Python3 is installed
if ! command -v python3 &> /dev/null; then
    echo "Error: Python3 is required but not found. Please install Python3."
    exit 1
fi

# Check if URL is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <video_url>"
    exit 1
fi

# Run the Python script with the provided URL
python3 main.py "$1"

if [ $? -eq 0 ]; then
    echo "Download completed successfully!"
    # Stage, commit, and push changes to the repository
    git add sigmadownloader.sh main.py read.md read.markdown
    git commit -m "Updated sigmadownloader with latest changes for URL processing"
    git push origin main
    if [ $? -eq 0 ]; then
        echo "Code pushed to repository successfully!"
    else
        echo "Failed to push code to repository. Check Git configuration."
        exit 1
    fi
else
    echo "Download failed. Check the URL or your internet connection."
    exit 1
fi