import os
import subprocess
import sys
import re

def check_yt_dlp():
    """Check if yt-dlp is installed, install if not"""
    try:
        subprocess.run(['yt-dlp', '--version'], check=True, capture_output=True)
    except (subprocess.CalledProcessError, FileNotFoundError):
        print("Installing yt-dlp...")
        try:
            subprocess.run([sys.executable, '-m', 'pip', 'install', 'yt-dlp'], check=True)
        except subprocess.CalledProcessError:
            print("Failed to install yt-dlp. Please install it manually: pip install yt-dlp")
            sys.exit(1)

def detect_platform(url):
    """Detect if the URL is from YouTube or Facebook"""
    youtube_pattern = r'youtube\.com|youtu\.be'
    facebook_pattern = r'facebook\.com|fb\.com|fb\.watch'
    
    if re.search(youtube_pattern, url, re.IGNORECASE):
        return "YouTube"
    elif re.search(facebook_pattern, url, re.IGNORECASE):
        return "Facebook"
    else:
        return None

def download_media(url, media_type, output_dir=f"{os.path.expanduser('~')}/Downloads/Media"):
    """Download video or audio from the given URL"""
    os.makedirs(output_dir, exist_ok=True)
    
    platform = detect_platform(url)
    if not platform:
        print("Error: URL is not from YouTube or Facebook.")
        sys.exit(1)
    
    print(f"Detected platform: {platform}")
    
    try:
        if media_type.lower() == 'audio':
            cmd = [
                'yt-dlp',
                '-f', 'bestaudio',
                '--extract-audio',
                '--audio-format', 'mp3',
                '-o', f'{output_dir}/%(title)s.%(ext)s',
                url
            ]
        else:  # video
            cmd = [
                'yt-dlp',
                '-f', 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]',
                '-o', f'{output_dir}/%(title)s.%(ext)s',
                url
            ]
        
        result = subprocess.run(cmd, capture_output=True, text=True)
        
        if result.returncode == 0:
            print(f"{media_type.capitalize()} download completed successfully!")
        else:
            print(f"Download failed: {result.stderr}")
            sys.exit(1)
            
    except Exception as e:
        print(f"An error occurred: {str(e)}")
        sys.exit(1)

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python main.py <video_url>")
        sys.exit(1)
    
    url = sys.argv[1]
    
    check_yt_dlp()
    
    # Prompt user to choose audio or video
    while True:
        media_choice = input("Do you want to download audio or video? (audio - A /video - V): ").lower()
        if media_choice in ['a', 'v']:
            break
        print("Invalid choice. Please enter 'audio' or 'video'.")
    
    download_media(url, media_choice)