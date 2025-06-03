#SigmaDownloader
##bash -c "$(curl -fsSL https://raw.githubusercontent.com/L0V3Y0UT00/sigmadownloader/main/run_sigmadownloader.sh)"
SigmaDownloader is a local command-line tool for Termux, Linux, and macOS that downloads video or audio from YouTube, Facebook, or TikTok. It installs all required dependencies, prompts for a URL, platform, and media type selection, and displays the downloaded file path.

Features





Automatically installs Python3, pip, and yt-dlp in Termux, Linux, or macOS.



Supports downloading from YouTube, Facebook, and TikTok.



Prompts for URL input, followed by platform choice (f - Facebook, t - TikTok, y - YouTube).



Prompts for media type choice (a - Audio, v - Video).



Saves downloaded files to ~/Downloads/Media (or /sdcard/Download/Media in Termux) and displays the file path.



Runs locally without Git operations.

Requirements





Internet connection for installing dependencies and downloading media.



Bash environment (Termux on Android, Linux, macOS, or WSL on Windows).



Termux: Storage permissions granted via termux-setup-storage.

Installation





Install Termux (for Android):





Download Termux from F-Droid or GitHub.



Update packages:

pkg update && pkg upgrade



Clone the Repository:





Install Git in Termux:

pkg install git



Clone the repository:

git clone https://github.com/L0V3Y0UT00/sigmadownloader /data/data/com.termux/files/home/workspaces/sigmadownloader
cd /data/data/com.termux/files/home/workspaces/sigmadownloader



Ensure Files are in Place:





sigmadownloader.sh



main.py



README.md (and optionally read.md, read.txt)



Make the Script Executable:

chmod +x /data/data/com.termux/files/home/workspaces/sigmadownloader/sigmadownloader.sh



Set Up Storage in Termux:





Grant storage access for /sdcard/Download/Media:

termux-setup-storage



Follow the prompt to allow storage permissions.

Usage

Run the script without a URL:

./sigmadownloader.sh

The script will:





Install dependencies (Python3, pip, yt-dlp).



Prompt for a URL (e.g., YouTube, Facebook, or TikTok URL).



Prompt for platform choice (f - Facebook, t - TikTok, y - YouTube).



Prompt for media type choice (a - Audio, v - Video).



Download the media to ~/Downloads/Media (or /sdcard/Download/Media in Termux) and display the file path.

Example URLs

https://www.youtube.com/watch?v=example
https://www.facebook.com/100044146913789/videos/665802319458932/
https://www.tiktok.com/@example/video/1234567890

Example Output

$ ./sigmadownloader.sh
Enter the video URL (YouTube, Facebook, or TikTok):
https://www.facebook.com/100044146913789/videos/665802319458/
Select platform (f - Facebook, t - TikTok, y - YouTube):
f
Select media type (a - Audio, v - Video):
v
Downloading from Facebook
Video download completed successfully!
Downloaded file path: /sdcard/Download/Media/example_video.mp4
Download completed successfully!

Troubleshooting





Usage Error: Provide a valid URL when prompted.



Dependency Installation Fails:





Termux: Run pkg update && pkg install python termux-api.



Linux: Run sudo apt install python3 python3-pip.



macOS: Run brew install python3.



Invalid URL or Platform: Ensure the URL is public and matches the selected platform.



Storage Access in Termux: Run termux-setup-storage and grant permissions.



Duplicate READMEs: Keep only README.md and delete read.md, read.txt` if not needed.



Download Fails: Update yt-dlp (pip install -U yt-dlp) and ensure the URL is public.

Notes





Respect YouTube, Facebook, and TikTok terms of service and copyright laws.



The repository includes read.md and read.txt. Consider keeping only README.md.



In Termux, downloads go to /sdcard/Download/Media (linked to ~/Downloads/Media).



No root access required in Termux.



No Git operations are performed; the script runs locally after cloning.

License

This project is provided as-is, with no warranty. Use responsibly and in compliance with local laws.

