#!/bin/bash

# Function to install packages on Debian/Ubuntu-based systems
install_packages_debian() {
    sudo apt-get update
    sudo apt-get install -y python3 python3-pip git
}

# Function to install packages on macOS
install_packages_macos() {
    brew install python3 git
}

# Function to detect OS and install dependencies
install_dependencies() {
    # Check if running on Linux (Debian/Ubuntu) or macOS
    if [[ -f /etc/debian_version ]]; then
        echo "Detected Debian/Ubuntu-based system. Installing dependencies..."
        install_packages_debian
    elif [[ "$(uname)" == "Darwin" ]]; then
        echo "Detected macOS. Installing dependencies..."
        # Check if Homebrew is installed, install if not
        if ! command -v brew &> /dev/null; then
            echo "Installing Homebrew..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        fi
        install_packages_macos
    else
        echo "Unsupported OS. Please install Python3, pip, and Git manually."
        exit 1
    fi
}

# Check and install Python3
if ! command -v python3 &> /dev/null; then
    echo "Python3 not found. Installing dependencies..."
    install_dependencies
fi

# Check and install pip
if ! command -v pip3 &> /dev/null; then
    echo "pip3 not found. Installing pip..."
    curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
    python3 get-pip.py
    rm get-pip.py
fi

# Check and install yt-dlp
if ! command -v yt-dlp &> /dev/null; then
    echo "Installing yt-dlp..."
    pip3 install yt-dlp
fi

# Check and install Git
if ! command -v git &> /dev/null; then
    echo "Git not found. Installing dependencies..."
    install_dependencies
fi

# Check if URL is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <video_url>"
    exit 1
fi

# Ensure main.py exists
if [ ! -f "main.py" ]; then
    echo "Error: main.py not found in the current directory."
    exit 1
fi

# Run the Python script with the provided URL
python3 main.py "$1"

if [ $? -eq 0 ]; then
    echo "Download completed successfully!"
    # Stage all files, including untracked ones
    git add sigmadownloader.sh main.py read.md read.markdown
    # Commit changes
    git commit -m "Updated sigmadownloader with latest changes for URL processing" || true
    # Pull with rebase to handle remote changes
    git pull --rebase origin main
    if [ $? -eq 0 ]; then
        # Push changes to the repository
        git push origin main
        if [ $? -eq 0 ]; then
            echo "Code pushed to repository successfully!"
        else
            echo "Failed to push code to repository. Check Git configuration or credentials."
            exit 1
        fi
    else
        echo "Failed to pull changes. Resolve conflicts manually with 'git rebase --continue' or 'git rebase --abort', then push again."
        exit 1
    fi
else
    echo "Download failed. Check the URL or your internet connection."
    exit 1
fi
