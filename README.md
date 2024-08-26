# Image Compression and Upload to S3

This repository contains tools for compressing image files in `.jpeg`, `.jpg`, and `.png` formats to `.webp` format using `cwebp` on Windows, and uploading the compressed files to Amazon S3 using the AWS CLI.

## Prerequisites

1. **cwebp**: A command-line tool for converting images to the WebP format.
   - Download and install from [Google's WebP project page](https://developers.google.com/speed/webp/download).
   - Ensure the `cwebp.exe` is added to your system's PATH.

2. **AWS CLI**: The Amazon Web Services Command Line Interface.
   - Download and install from the [AWS CLI official documentation](https://aws.amazon.com/cli/).
   - Configure it with your AWS credentials using `aws configure`.

## Benefits of Using WebP Format

- **Storage Savings**: The WebP format can significantly reduce the storage size of images. On average, WebP images are 25-34% smaller than equivalent images in JPEG or PNG format with similar quality. This reduction in file size helps save storage space and reduces the bandwidth required for image delivery.

- **Improved Latency and Rendering Speed**: WebP's smaller file sizes lead to faster download times, improving website latency. This optimization results in quicker rendering of images on web pages, enhancing the user experience, especially on mobile devices or slower networks.

## Usage

### 1. Compress Images to WebP Format

The `compress_to_webp.bat` script compresses all `.jpeg`, `.jpg`, and `.png` files in a specified directory to the `.webp` format.

#### Script: `convert_and_copy.bat`

```batch
@echo off
setlocal enabledelayedexpansion

set "src_dir=C:\Users\Administrator\Pictures\Photos"
set "dest_dir=C:\Users\Administrator\Pictures\Photos-Compress"
set "cwebp_path=C:\Users\Administrator\Downloads\libwebp-1.4.0-windows-x64\libwebp-1.4.0-windows-x64\bin\cwebp.exe"

REM Create the destination directory if it doesn't exist
if not exist "%dest_dir%" mkdir "%dest_dir%"

REM Convert .jpg and .png files to .webp, and copy other files
for /r "%src_dir%" %%i in (*.jpg *.jpeg *.png) do (
    REM Create corresponding directory in destination
    set "relative_path=%%~pi"
    set "relative_path=!relative_path:%src_dir%=!"
    mkdir "%dest_dir%!relative_path!" 2>nul

    REM Convert image files
    "%cwebp_path%" "%%i" -o "%dest_dir%!relative_path!%%~ni.webp"
)

REM Copy all other files with different extensions
for /r "%src_dir%" %%i in (*.*) do (
    if /I not "%%~xi"==".jpg" if /I not "%%~xi"==".jpeg" if /I not "%%~xi"==".png" (
        set "relative_path=%%~pi"
        set "relative_path=!relative_path:%src_dir%=!"
        mkdir "%dest_dir%!relative_path!" 2>nul
        
        copy "%%i" "%dest_dir%!relative_path!" 2>nul
    )
)

echo Conversion and file copying complete!
pause
```

Replace C:\Users\Administrator\Pictures\Photos with the actual directory path containing your images.

### 2. Upload Compressed Files to S3
The upload_to_s3.bat script uploads all files from the webp_output directory to a specified S3 bucket using the aws s3 sync command.

#### Script: `upload_to_s3.bat`

```batch
@echo off
REM Define the source and destination directories
set SOURCE_DIR=C:\Users\Administrator\Pictures\Photos-Compress
set S3_BUCKET=s3://my-drive-bucket/

REM Run the AWS CLI command to sync the files
aws s3 sync "%SOURCE_DIR%" "%S3_BUCKET%"

REM Check if the sync was successful
if %ERRORLEVEL% neq 0 (
    echo Sync failed!
    exit /b %ERRORLEVEL%
) else (
    echo Sync successful!
)

pause
```

Replace C:\Users\Administrator\Pictures\Photos-Compress with the actual directory path containing your .webp files, and s3://your-bucket-name/your-folder with your actual S3 bucket path.

## Notes
The compress_to_webp.bat script compresses images with a quality setting of 80. You can adjust this by changing the -q 80 parameter in the script.
Ensure that your AWS credentials are configured properly before running the upload_to_s3.bat script.

## License
This project is licensed under the MIT License - see the LICENSE file for details.

This version includes details on the benefits of using WebP format, such as reduced storage size and improved loading times, which can optimize web performance.
