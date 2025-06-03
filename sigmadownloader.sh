```bash
#!/bin/bash

# Function to install packages on Termux
install_packages_termux() {
    pkg update -y && pkg upgrade -y
    pkg install -y python
    pip install --upgrade pip
}

# Function to install packages on Debian/Ubuntu-based systems
install_packages_debian() {
    sudo apt-get update
    sudo apt-get install -y python3 python3-pip
}

# Function to install packages on macOS
install_packages_macos() {
    brew install python3
}

# Function to detect OS and install dependencies
install_dependencies() {
    if [[ -n "$TERMUX_VERSION" ]]; then
        echo "Detected Termux. Installing dependencies..."
        install_packages_termux
        # Ensure Termux storage is set up
        if ! command -v termux-setup-storage &> /dev/null; then
            pkg install -y termux-api
        fi
        termux-setup-storage
    elif [[ -f /etc/debian_version ]]; then
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
        echo "Unsupported OS. Please install Python3 and pip manually."
        exit 1
    fi
}

# Check and install Python
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
    pip3 install -U yt-dlp
fi

# Ensure main.py exists
if [ ! -f "main.py" ]; then
    echo "Error: main.py not found in the current directory."
    exit 1
fi

# Prompt for URL
echo "Enter the video URL (YouTube, Facebook, or TikTok):"
read -r url
if [ -z "$url" ]; then
    echo "Error: No URL provided. Exiting."
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
    *) echo "Invalid platform choice. Exiting."; exit 1 ;;
esac

# Prompt for media type choice
echo "Select media type (a - Audio, v - Video):"
read -n 1 media_choice
echo ""
case $media_choice in
    a|A) media_type="audio" ;;
    v|V) media_type="video" ;;
    *) echo "Invalid media type choice. Exiting."; exit 1 ;;
esac

# Run the Python script with the provided URL, platform, and media type
output=$(python3 main.py "$url" "$platform" "$media_type" 2>&1)
if [ $? -eq 0 ]; then
    echo "Download completed successfully!"
    # Extract file path from Python script output
    file_path=$(echo "$output" | grep "Downloaded file path:" | cut -d ' ' -f 3-)
    if [ -n "$file_path" ]; then
        echo "Downloaded file saved to: $file_path"
    else
        echo "Warning: Could not determine downloaded file path."
    fi
else
    echo "Download failed. Check the URL, platform choice, or internet connection."