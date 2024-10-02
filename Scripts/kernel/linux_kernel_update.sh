#!/bin/bash

# This script will be used to automate the change of the Kernel from 6.9.12 to 6.10.6 on a fresh install for increased WiFi performance.

# Exit immediately if a command exits with a non-zero status.
set -e

# Download the kernel modules.
wget https://kernel.ubuntu.com/mainline/v6.10.6/amd64/linux-headers-6.10.6-061006-generic_6.10.6-061006.202408190440_amd64.deb
wget https://kernel.ubuntu.com/mainline/v6.10.6/amd64/linux-headers-6.10.6-061006_6.10.6-061006.202408190440_all.deb
wget https://kernel.ubuntu.com/mainline/v6.10.6/amd64/linux-image-unsigned-6.10.6-061006-generic_6.10.6-061006.202408190440_amd64.deb
wget https://kernel.ubuntu.com/mainline/v6.10.6/amd64/linux-modules-6.10.6-061006-generic_6.10.6-061006.202408190440_amd64.deb

# Install the kernel modules.
sudo dpkg -i linux-headers-6.10.6-061006_6.10.6-061006.202408190440_all.deb
sudo dpkg -i linux-headers-6.10.6-061006-generic_6.10.6-061006.202408190440_amd64.deb
sudo dpkg -i linux-modules-6.10.6-061006-generic_6.10.6-061006.202408190440_amd64.deb
sudo dpkg -i linux-image-unsigned-6.10.6-061006-generic_6.10.6-061006.202408190440_amd64.deb

# Fix broken dependencies if any.
sudo apt --fix-broken install

# Update grub.
sudo update-grub

# Reboot the system with a countdown.
echo "Rebooting in 5 seconds..."
for i in {5..1}; do
    echo "$i..."
    sleep 1
done
echo "Rebooting now!"
sudo reboot
