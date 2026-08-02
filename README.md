### flac2opus-ffmpeg
  A Simple batch audio file conversion script written in Bash for Termux.

#### Dependancies:
ffmpeg: For encoding audio via libopus and extracting image data
kid3: kid3-cli for tag editing and image embedding

#### Installation:
---
##### Termux:
Install dependencies
```bash
pkg update && pkg upgrade && pkg install ffmpeg kid3 git
```
`cd` to or `mkdir` a suitable directory for the script.

Then run:
```bash
# Download the Termux flac2opus script;
curl "" >> flac2opus && \
# Make it executable;
chmod +x flac2opus && \
# Soft link to system bin folder for convenience
ln -s flac2opus /data/data/com.termux/files/use/bin/flac2opus
```

Usage: 
Termux:
Run flac2opus from any directory containing flac files.
New files will be output to the new sub-directory: ./Export
