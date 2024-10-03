#!/bin/bash:


set -e  # Exit on error

# This script will be used to create the initial configuration for new hire laptops and cleaning up configuration from Odoo BE image to work better for BU.
# Written by chno
# Last updated: Thu Oct  3 02:10:08 PM EDT 2024
# Last update: Updated atera URL to a base one instead of department specific.

echo "Starting system updates..."

# Phase 1: System Update and Package Installation

# Start by updating the system.
echo "Updating, upgrading, and cleaning system..."
sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y

# Install atera agent and put the new user into the Direct Sales/MMC Site.
echo "Installing Atera agent..."
sudo wget -O - "${ATERA_URL}" | sudo bash

# Install ufw
echo "Installing UFW..."
sudo apt install ufw -y

# Install preload
echo "Installing and enabling preload..."
sudo apt install preload -y

# Install ZRAM (Phase 1: Only installation)
echo "Installing ZRAM to compress RAM and limit swapping..."
sudo apt install zram-tools -y

# Install htop for system monitoring.
echo "Installing htop..."
sudo apt install htop -y

# Phase 2: Configuration

# Adjust the swappiness of the system to make sure the system uses RAM more than swap.
# Check if vm.swappiness is already set, if so, modify it. Otherwise, append it.
echo "Checking if swappiness is set, if it is then modifying it. If it is not set, appending it to /etc/sysctl.conf..."
if grep -q '^vm.swappiness=' /etc/sysctl.conf; then
    sudo sed -i 's/^vm.swappiness=.*/vm.swappiness=10/' /etc/sysctl.conf
else
    echo "vm.swappiness=10" | sudo tee -a /etc/sysctl.conf
fi

# Apply the changes immediately.
echo "Applying swappiness changes immediately..."
sudo sysctl -p

### Security Updates ###

# Install and configure unattended upgrades.
echo "Installing unattended upgrades for automatic security updates..."
sudo apt install unattended-upgrades -y

# Enable automatic updates by modifying the config files.
echo "Enabling automatic updates..."
sudo bash -c 'cat > /etc/apt/apt.conf.d/20auto-upgrades <<EOF
APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Unattended-Upgrade "1";
EOF'

# Modify /etc/apt/apt.conf.d/50unattended-upgrades for security updates
echo "Modifying 50unattended-upgrades to enable automatic security updates..."
sudo sed -i 's#//\s*\"\o=Ubuntu,a=${distro_codename}-updates\";#\"o=Ubuntu,a=${distro_codename}-updates\";#' /etc/apt/apt.conf.d/50unattended-upgrades

# Start unattended-upgrades service
echo "Restarting unattended-upgrades service..."
sudo systemctl restart unattended-upgrades

# Firewall setup
echo "Setting up firewall rules with ufw..."

# Enable the firewall
echo "Enabling ufw firewall..."
sudo ufw enable

# Block incoming traffic by default
sudo ufw default deny incoming

# Allow outgoing traffic by default
sudo ufw default allow outgoing

# Allow ssh
sudo ufw allow ssh

# Allow http
sudo ufw allow http

# Allow https
sudo ufw allow https

# Allow RDP
sudo ufw allow 3389/tcp

# Allow DNS
sudo ufw allow out 53/udp

# Allow DHCP in and out
sudo ufw allow in 67/udp
sudo ufw allow out 68/udp

# Allow postgres
sudo ufw allow 5432/tcp

# Allow NTP
sudo ufw allow 123/udp

# Allow outbound mailing
sudo ufw allow out 587/tcp
sudo ufw allow out 465/tcp


echo "Firewall settings done...Enabling logging..."
sudo ufw logging medium

echo "Script execution completed. Consider rebooting the system to ensure all updates are applied."

