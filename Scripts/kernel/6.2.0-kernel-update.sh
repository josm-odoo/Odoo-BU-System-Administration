#!/bin/bash

# Script used to downgrade the kernel to 6.2.0.

# Exit immediately if a command exits with a non-zero status.
set -e

# URLs for the kernel modules.
BASE_URL="https://kernel.ubuntu.com/mainline/v6.2/amd64/"
FILES=(
  "linux-headers-6.2.0-060200_6.2.0-060200.202302191831_all.deb"
  "linux-headers-6.2.0-060200-generic_6.2.0-060200.202302191831_amd64.deb"
  "linux-modules-6.2.0-060200-generic_6.2.0-060200.202302191831_amd64.deb"
  "linux-image-unsigned-6.2.0-060200-generic_6.2.0-060200.202302191831_amd64.deb"
)

# Download each file.
for FILE in "${FILES[@]}"; do
    wget "${BASE_URL}${FILE}" || { echo "Failed to download $FILE"; exit 1; }
done

for FILE in "${FILES[@]}"; do
  sudo dpkg -i "$FILE" || { echo "Failed to install $FILE"; exit 1; }
done

# Fix broken dependencies if any.
sudo apt --fix-broken install


# Set the 6.2.0 kernel as the default in GRUB.
sudo sed -i 's/GRUB_DEFAULT=.*/GRUB_DEFAULT="Advanced options for Ubuntu>Ubuntu, with Linux 6.2.0-060200-generic"/' /etc/default/grub
sudo update-grub

# Reboot the system with a countdown.
echo "Rebooting in 5 seconds..."
for i in {5..1}; do
  echo "$i..."
  sleep 1
done

echo "Rebooting now..."
sudo reboot
