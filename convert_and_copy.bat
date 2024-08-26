@echo off
setlocal enabledelayedexpansion

set "src_dir=C:\Users\Administrator\Pictures\Photos-20240824T055115Z\Photos"
set "dest_dir=C:\Users\Administrator\Pictures-Compress"
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
