SigmaDownloader

SigmaDownloader is a command-line tool that allows you to download audio or video from YouTube and Facebook by providing a URL. It automatically detects the platform and prompts you to choose between downloading the audio (MP3) or video (MP4).

Features





Automatically detects whether the provided URL is from YouTube or Facebook.



Supports downloading audio (MP3) or video (MP4) formats.



Saves downloaded files to ~/Downloads/Media.



Uses yt-dlp for reliable downloading.

Requirements





Python 3: Ensure Python 3 is installed.



pip: Python package manager to install dependencies.



yt-dlp: Automatically installed by the script if missing.



Bash: Required to run the sigmadownloader.sh script (available on Linux/macOS or WSL on Windows).

Installation





Clone or download the repository: Ensure you have the following files in your project directory:





sigmadownloader.sh



main.py



Make the bash script executable:

chmod +x sigmadownloader.sh



Install Python 3 (if not already installed):





On Ubuntu/Debian: sudo apt update && sudo apt install python3 python3-pip



On macOS: brew install python3



On Windows (using WSL): Follow Ubuntu instructions or install Python from the official website.

Usage





Run the bash script with a YouTube or Facebook URL:
