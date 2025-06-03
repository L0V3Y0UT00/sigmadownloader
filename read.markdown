# SigmaDownloader

SigmaDownloader is a command-line tool that allows you to download audio or video from YouTube and Facebook by providing a URL. It automatically detects the platform and prompts you to choose between downloading the audio (MP3) or video (MP4).

## Features
- Automatically detects whether the provided URL is from YouTube or Facebook.
- Supports downloading audio (MP3) or video (MP4) formats.
- Saves downloaded files to `~/Downloads/Media`.
- Uses `yt-dlp` for reliable downloading.

## Requirements
- **Python 3**: Ensure Python 3 is installed.
- **pip**: Python package manager to install dependencies.
- **yt-dlp**: Automatically installed by the script if missing.
- **Bash**: Required to run the `sigmadownloader.sh` script (available on Linux/macOS or WSL on Windows).

## Installation
1. **Clone or download the repository**:
   Ensure you have the following files in your project directory:
   - `sigmadownloader.sh`
   - `main.py`

2. **Make the bash script executable**:
   ```bash
   chmod +x sigmadownloader.sh
   ```

3. **Install Python 3 (if not already installed)**:
   - On Ubuntu/Debian: `sudo apt update && sudo apt install python3 python3-pip`
   - On macOS: `brew install python3`
   - On Windows (using WSL): Follow Ubuntu instructions or install Python from the official website.

## Usage
1. Run the bash script with a YouTube or Facebook URL:
   ```bash
   ./sigmadownloader.sh <video_url>
   ```
   Examples:
   ```bash
   ./sigmadownloader.sh https://www.youtube.com/watch?v=example
   ./sigmadownloader.sh https://www.facebook.com/watch/?v=example
   ```

2. When prompted, choose the download type:
   - Enter `audio` to download the audio in MP3 format.
   - Enter `video` to download the video in MP4 format.

3. Files are saved to `~/Downloads/Media`.

## Troubleshooting
- **Error: "Usage: sigmadownloader.sh <video_url>"**: Provide a valid YouTube or Facebook URL when running the script.
- **Python3 not found**: Install Python 3 using your system's package manager or download it from python.org.
- **yt-dlp installation fails**: Manually install it with `pip install yt-dlp`.
- **Invalid URL**: Ensure the URL is from YouTube (e.g., youtube.com, youtu.be) or Facebook (e.g., facebook.com, fb.watch).

## Notes
- Always respect the terms of service of YouTube and Facebook, as well as applicable copyright laws, when downloading content.
- The script automatically installs `yt-dlp` if it's not found, but requires an active internet connection.
- Ensure `sigmadownloader.sh` and `main.py` are in the same directory.

## LicenseGIT
This project is provided as-is, with no warranty. Use responsibly and in compliance with platform terms and local laws.