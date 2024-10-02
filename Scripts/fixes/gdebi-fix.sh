#!/bin/bash

### Script to fix Gdebi installer saying another package manager is running. The fix is to reconfigure dpkg then reinstall gdebi.
# Written by chno
# Last updated on: Wed Oct  2 09:43:16 AM EDT 2024

set -e

# Reconfigure dpkg
echo "Reconfiguring dpkg..."
sudo dpkg --configure -a

# Reinstll gdebi in case
sudo apt-get install --reinstall gdebi

echo "Script completed. Please try and reinstall the package..."

