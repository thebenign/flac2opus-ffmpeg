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
1. Install dependencies
```bash
pkg update && pkg upgrade && pkg install ffmpeg kid3
```
2. `cd` to or `mkdir` a suitable directory for the script.

3. Download the Termux flac2opus script, make it executable, and sym link to system bin folder for convenience
```bash
curl https://github.com/thebenign/flac2opus-ffmpeg/blob/main/flac2opus >> flac2opus && \
chmod +x flac2opus && \
ln -s flac2opus /data/data/com.termux/files/use/bin/flac2opus
```
### Linux (Not Ready)
> [!Warning]
> This install procedure will not work yet!
> 
> flac2opus was designed for Termux. With minor modifications it should run under any Linux which has ffmpeg and kid3 available.
> 
> I will upload a Linux script soon.

1. Install dependencies: Using your package manager, install `ffmpeg` and `kid3`
2. `cd` to or `mkdir` a suitable directory for the script.
3. Download the Linux flac2opus script, make it executable, and sym link to system bin folder for convenience
```bash
curl https://github.com/thebenign/flac2opus-ffmpeg/blob/main/flac2opus >> flac2opus && \
chmod +x flac2opus && \
ln -s flac2opus usr/local/bin/flac2opus
```

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
