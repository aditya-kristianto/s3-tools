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
