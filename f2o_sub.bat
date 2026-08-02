@echo off
setlocal

:: ------------------------------------------------------------
:: User-configurable binaries
:: ------------------------------------------------------------
set "FFMPEG=ffmpeg"
set "KID3=kid3-cli"

:: ------------------------------------------------------------
:: Internal variables
:: ------------------------------------------------------------
set "outdir=Export"
set /a counter=0
set /a success=0
set /a failed=0
set "tmpcover=%TEMP%\flac2opus_cover.jpg"

:: ------------------------------------------------------------
:: ANSI color support (Windows 10+)
:: ------------------------------------------------------------
for /f %%a in ('echo prompt $E ^| cmd') do set "ESC=%%a"

set "NOCOLOR=%ESC%[0m"
set "LIGHTGRAY=%ESC%[0;37m"
set "LIGHTRED=%ESC%[1;31m"
set "LIGHTGREEN=%ESC%[1;32m"
set "LIGHTBLUE=%ESC%[1;34m"
set "LIGHTPURPLE=%ESC%[1;35m"

echo(
echo %LIGHTPURPLE%  Starting Flac to Opus Batch Converter%NOCOLOR%
echo(

:: ------------------------------------------------------------
:: Create Export directory and copy any JPEG album art images
:: ------------------------------------------------------------
echo %LIGHTGRAY%  Making export folder and copying album art...%LIGHTPURPLE%
echo %LIGHTPURPLE%_______________________________%NOCOLOR%
echo(
if not exist "%outdir%\" mkdir "%outdir%"
for %%a in (*.jpg *.jpeg) do (
    if exist "%%a" copy /Y "%%a" "%outdir%\" >nul
)

:: Cleanup any stale temp files from a previous run
del /f flac2opus_temp_*.flac >nul 2>&1
del /f "%outdir%\flac2opus_temp_*.opus" >nul 2>&1

:: ------------------------------------------------------------
:: Main loop
:: ------------------------------------------------------------
for %%f in (*.flac) do (
    if exist "%%f" call :process_file "%%f"
)

:: Final cleanup of temp cover art
if exist "%tmpcover%" del /f "%tmpcover%" >nul 2>&1

:: ------------------------------------------------------------
:: Summary
:: ------------------------------------------------------------
echo %LIGHTPURPLE%_______________________________%NOCOLOR%
echo(
echo %LIGHTBLUE%  Export complete: %success% files converted, %failed% failed
echo   Files output to ./Export%NOCOLOR%
endlocal
exit /b

:: ------------------------------------------------------------
:: Subroutine: process one file
:: ------------------------------------------------------------
:process_file
set /a counter+=1
set "safename=flac2opus_temp_%counter%.flac"
set "safeopus=%outdir%\flac2opus_temp_%counter%.opus"

:: Print the original filename safely without putting it in a raw echo
set /p "dummy=%LIGHTPURPLE%^> Track: " <nul
dir /b "%~1" 2>nul
echo %NOCOLOR%

:: Rename the original to a safe name so the rest of the script
:: never has to expand the raw filename
ren "%~1" "%safename%"

:: "Tag 1" (ID3v1) tags are incompatible with Opus
echo %LIGHTGRAY%    Cleaning up tags...
"%KID3%" -c "tag 1 remove all" "%safename%" >nul 2>&1

:: Extract embedded cover art
echo     Extracting cover art...
if exist "%tmpcover%" del /f "%tmpcover%" >nul 2>&1
"%FFMPEG%" -hide_banner -loglevel error -y -i "%safename%" -an -vcodec copy "%tmpcover%" >nul 2>&1

:: Convert the FLAC to Opus
echo     Converting to Opus...
"%FFMPEG%" -hide_banner -loglevel warning -y -i "%safename%" -c:a libopus -b:a 192k -application audio -map_metadata 0 "%safeopus%" 2>nul

if not errorlevel 1 (
    :: Embed extracted cover art
    if exist "%tmpcover%" (
        echo     Embedding cover art...
        :: NOTE: quote style below is a best-guess. kid3-cli may need
        :: backslash-escaping or a different quote nesting.
        "%KID3%" -c "set picture:%tmpcover% ""Cover Art""" "%safeopus%" >nul 2>&1
        del /f "%tmpcover%" >nul 2>&1
    ) else (
        echo     No cover art... Skipping
    )

    echo %LIGHTGREEN%    Done%NOCOLOR%
    echo(
    set /a success+=1

    :: Rename the finished opus back to the original base name
    ren "%safeopus%" "%~n1.opus"
    :: Rename the original flac back to its real name
    ren "%safename%" "%~nx1"
) else (
    :: Clean up broken partial file and temp art on failure
    if exist "%safeopus%" del /f "%safeopus%" >nul 2>&1
    if exist "%tmpcover%" del /f "%tmpcover%" >nul 2>&1
    echo %LIGHTRED%    Failed to convert%NOCOLOR%
    echo(
    set /a failed+=1
    ren "%safename%" "%~nx1"
)
exit /b
