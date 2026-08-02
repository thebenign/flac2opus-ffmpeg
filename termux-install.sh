cd $TERMUX__HOME
echo "Termux flac2opus install script"
echo "Checking shared storage..."
if [ -e "~/storage" ]; then
    termux-setup-storage
    echo "Setting up shared storage..."
else
    echo "Already set up."
fi
echo "____________________"

echo "Updating packages..."
apt-get update
apt-get -y -o Dpkg::Options::="--force-confold" -o Dpkg::Progress-Fancy=1 -o APT::Color=1 upgrade

echo "Installing dependencies..."
apt-get install -y x11-repo
apt-get install -y -o Dpkg::Progress-Fancy=1 -o APT::Color=1 ffmpeg kid3

echo "Making install directory..."
mkdir -p .local/bin
cd .local/bin

echo "Downloading flac2opus into ~/.local/bin/ ..."
curl -o flac2opus https://raw.githubusercontent.com/thebenign/termux-flac2opus/refs/heads/main/flac2opus
# Make it executable
chmod +x flac2opus

echo "Symlinking script to Termux's /usr/bin/..."
cd $TERMUX__PREFIX/bin
# Symlink script file to termux binary directory
ln -s ${TERMUX__HOME}/.local/bin/flac2opus .
cd $TERMUX__HOME

echo "Installation complete! Run flac2opus inside any folder of flac files to start converting."