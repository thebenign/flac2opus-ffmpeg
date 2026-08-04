# Termux flac2opus
#### A Termux-based batch audio file conversion script written in Bash.

+ Uses ffmpeg to batch convert Flac files into Opus [192kbps, vbr]

+ Preserves metadata

+ Deletes ID3v1 tags (Illegal tag for Opus)

+ Preserves album art

+ Embeds track art in Opus files

## Dependencies
+ ffmpeg: For encoding audio via libopus and extracting image data.
+ kid3: kid3-cli for tag editing and image embedding

## Installation
### Termux (Ready)
> [!Note]
> Be sure to install Termux from F-Droid or Github. The Google Play Store version is very old and will not work. If you have this version, you must uninstall it and install the F-Droid or Github version.

Copy and paste this command into Termux to install depencies and flac2opus:
```bash
bash <(curl -s https://raw.githubusercontent.com/thebenign/termux-flac2opus/refs/heads/main/termux-install.sh)
```
If you have not installed x11 packages before, installing dependencies can take some time. Please be patient.

### Linux (Not Ready)
> [!Warning]
> The install procedure will not work for Linux!
> 
> flac2opus was designed for Termux. With minor modifications it should run under any Linux which has ffmpeg and kid3 available.
> 
> I will upload a Linux script soon.

### Windows (Not Ready)
> [!Warning]
> Do not use the windows version. It is being developed still and may cause permanent data loss. The script lives here while I work on it.

(Basic outline)
1. Download and install kid3 from https://kid3.kde.org/#download
2. Download and install ffmpeg from https://www.gyan.dev/ffmpeg/builds/
3. ~~Download the Windows flac2opus script file~~ Not ready!
4. Move the file to a directory you'll remember
5. Add the script path to your PATH variable

## Usage: 
### Termux and Linux
Run `flac2opus` from any directory containing flac files. There are no options.
New files will be output to the new sub-directory: ./Export
