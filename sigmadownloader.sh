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
    if [[ -f /etc/debian_version ]]; then
        echo "Detected Debian/Ubuntu-based system. Installing dependencies..."
        install_packages_debian
    elif [[ "$(uname)" == "Darwin" ]]; then
        echo "Detected macOS. Installing dependencies..."
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

# Prompt for platform choice
echo "Select platform (f - Facebook, t - TikTok, y - YouTube):"
read -n 1 platform_choice
echo ""
case $platform_choice in
    f|F) platform="facebook" ;;
    t|T) platform="tiktok" ;;
    y|Y) platform="youtube" ;;
    *) echo "Invalid choice. Exiting."; exit 1 ;;
esac

# Prompt for media type choice
echo "Select media type (a - Audio, v - Video):"
read -n 1 media_choice
echo ""
case $media_choice in
    a|A) media_type="audio" ;;
    v|V) media_type="video" ;;
    *) echo "Invalid choice. Exiting."; exit 1 ;;
esac

# Run the Python script with the provided URL, platform, and media type
output=$(python3 main.py "$1" "$platform" "$media_type" 2>&1)
if [ $? -eq 0 ]; then
    echo "Download completed successfully!"
    # Extract file path from Python script output
    file_path=$(echo "$output" | grep "Downloaded file path:" | cut -d ' ' -f 3-)
    if [ -n "$file_path" ]; then
        echo "Downloaded file saved to: $file_path"
    else
        echo "Warning: Could not determine downloaded file path."
    fi
    # Stage all files
    git add sigmadownloader.sh main.py README.md read.md read.txt 2>/dev/null
    # Check if there are changes to commit
    if git status --porcelain | grep . >/dev/null; then
        git commit -m "Auto: Downloaded $media_type from $platform to $file_path"
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
            echo "Failed to pull changes. Resolve conflicts manually with 'git rebase --continue' or 'git rebase --abort'."
            exit 1
        fi
    else
        echo "No changes to commit. Repository is up to date."
    fi
else
    echo "Usage Error: $0 [URL |media|]"
    echo "Download failed. Check the URL, platform choice, or credentials."
    echo "Error output: $output"
    exit 1
fi