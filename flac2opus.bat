@echo off
setlocal

:: ------------------------------------------------------------:: User-configurable binaries
:: ------------------------------------------------------------
set "FFMPEG=ffmpeg"
set "KID3=kid3-cli"

:: ------------------------------------------------------------
:: Internal variables
:: ------------------------------------------------------------
set "outdir=Export"
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

:: ------------------------------------------------------------
:: Main loop: iterate all FLAC files in current directory
:: ------------------------------------------------------------
for %%f in (*.flac) do (
    if exist "%%f" (
        echo %LIGHTPURPLE%^> Track: %%f

        :: "Tag 1" (ID3v1) tags are incompatible with Opus
        echo %LIGHTGRAY%    Cleaning up tags...
        %KID3% -c "tag 1 remove all" "%%f" >nul 2>&1

        :: Extract embedded cover art
        echo     Extracting cover art...
        if exist "%tmpcover%" del /f "%tmpcover%" >nul 2>&1
        %FFMPEG% -hide_banner -loglevel error -y -i "%%f" -an -vcodec copy "%tmpcover%" >nul 2>&1

        :: Convert the FLAC to Opus
        echo     Converting to Opus...
        %FFMPEG% -hide_banner -loglevel warning -y -i "%%f" -c:a libopus -b:a 192k -application audio -map_metadata 0 "%outdir%\%%~nf.opus" 2>nul
        if not errorlevel 1 (
            :: Embed extracted cover art
            if exist "%tmpcover%" (
                echo     Embedding cover art...
                :: NOTE: quote style below is a best-guess. kid3-cli may need
                :: backslash-escaping or a different quote nesting.
                %KID3% -c "set picture:%tmpcover% ""Cover Art""" "%outdir%\%%~nf.opus" >nul 2>&1
                del /f "%tmpcover%" >nul 2>&1
            ) else (
                echo     No cover art... Skipping
            )

            echo %LIGHTGREEN%    Done%NOCOLOR%
            echo(
            set /a success+=1
        ) else (
            :: Clean up broken partial file and temp art on failure
            if exist "%outdir%\%%~nf.opus" del /f "%outdir%\%%~nf.opus" >nul 2>&1
            if exist "%tmpcover%" del /f "%tmpcover%" >nul 2>&1
            echo %LIGHTRED%    Failed to convert%NOCOLOR%
            echo(
            set /a failed+=1
        )
    )
)

:: Final cleanup of temp cover art
if exist "%tmpcover%" del /f "%tmpcover%" >nul 2>&1

echo %LIGHTPURPLE%_______________________________%NOCOLOR%
echo(
echo %LIGHTBLUE%  Export complete: %success% files converted, %failed% failed
echo   Files output to ./Export%NOCOLOR%
