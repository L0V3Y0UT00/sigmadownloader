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
            subprocess.run([sys.executable, '-m', 'pip', 'install', '-U', 'yt-dlp'], check=True)
        except subprocess.CalledProcessError:
            print("Failed to install yt-dlp. Please install it manually with: pip install -U yt-dlp")
            sys.exit(1)

def detect_platform(platform, url):
    """Verify if the selected platform matches the provided URL"""
    platform_patterns = {
        'youtube': r'youtube\.com|youtu\.be',
        'facebook': r'facebook\.com|fb\.com|fb\.watch',
        'tiktok': r'tiktok\.com'
    }
    
    if platform.lower() not in platform_patterns:
        print(f"Error: Invalid platform {platform}. Supported platforms: YouTube, Facebook, TikTok.")
        sys.exit(1)
    
    pattern = platform_patterns[platform.lower()]
    if not re.search(pattern, url, re.IGNORECASE):
        print(f"Error: URL does not match selected platform {platform}.")
        sys.exit(1)
    
    return platform.lower()

def download_media(url, platform, media_type, output_dir=f"{os.path.expanduser('~')}/Downloads/Media"):
    """Download video or audio from the given URL and return file path"""
    os.makedirs(output_dir, exist_ok=True)
    
    platform = detect_platform(platform, url)
    print(f"Downloading from {platform.capitalize()}")
    
    try:
        if media_type.lower() == 'audio':
            cmd = [
                'yt-dlp',
                '-f', 'bestaudio',
                '--extract-audio',
                '--audio-format', 'mp3',
                '-o', f'{output_dir}/%(title)s.%(ext)s',
                '--print', 'filename',
                url
            ]
        else:  # video
            cmd = [
                'yt-dlp',
                '-f', 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]',
                '-o', f'{output_dir}/%(title)s.%(ext)s',
                '--print', 'filename',
                url
            ]
        
        result = subprocess.run(cmd, capture_output=True, text=True)
        
        if result.returncode == 0:
            print(f"{media_type.capitalize()} download completed successfully!")
            # Extract file path from yt-dlp output
            file_path = result.stdout.strip().split('\n')[-1]
            if os.path.exists(file_path):
                print(f"Downloaded file path: {file_path}")
            else:
                print("Warning: File path not found, but download reported success.")
            return file_path
        else:
            print(f"Download failed: {result.stderr}")
            sys.exit(1)
            
    except Exception as e:
        print(f"An error occurred: {str(e)}")
        sys.exit(1)

if __name__ == "__main__":
    if len(sys.argv) < 4:
        print("Usage: python main.py <video_url> <platform> <media_type>")
        sys.exit(1)
    
    url = sys.argv[1]
    platform = sys.argv[2]
    media_type = sys.argv[3]
    
    check_yt_dlp()
    
    if media_type.lower() not in ['audio', 'video']:
        print("Invalid media type. Must be 'audio' or 'video'.")
        sys.exit(1)
    
    download_media(url, platform, media_type)