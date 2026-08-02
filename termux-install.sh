cd $TERMUX__HOME
echo -e "\033[1;35m [[ Termux flac2opus install script ]]\n"
echo "\033[0;37m     Checking shared storage..."
if [ -e "~/storage" ]; then
    termux-setup-storage
    echo "       Setting up shared storage..."
else
    echo "       Already set up."
fi

echo -e "\033[1;35m\n     Updating packages...\n"
apt-get update
apt-get -y -o Dpkg::Options::="--force-confold" -o Dpkg::Progress-Fancy=1 -o APT::Color=1 upgrade

echo -e "\n     Installing dependencies...\n"
apt-get install -y x11-repo
apt-get install -y -o Dpkg::Progress-Fancy=1 -o APT::Color=1 ffmpeg kid3

echo "\n     Making install directory...\n"
mkdir -p .local/bin
cd .local/bin

echo "     Downloading flac2opus into ~/.local/bin/ ...\n"
curl -s -o flac2opus https://raw.githubusercontent.com/thebenign/termux-flac2opus/refs/heads/main/flac2opus
# Make it executable
chmod +x flac2opus

echo "     Symlinking script to Termux's /usr/bin/...\n"
cd $TERMUX__PREFIX/bin
# Symlink script file to termux binary directory
ln -s ${TERMUX__HOME}/.local/bin/flac2opus .
cd $TERMUX__HOME

echo -e "\033[1;32m   Installation complete!"
echo -e "\033[0m   Run flac2opus inside any folder of flac files to start converting."

https://raw.githubusercontent.com/thebenign/termux-flac2opus/refs/heads/main/termux-install.sh