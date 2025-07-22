#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status.

# Function to download and save a file from a URL
download_file() {
    local url=$1
    local destination=$2
    echo "Downloading $url to $destination..."
    curl -o "$destination" "$url"
}

# URLs for the configuration files
USER_CONFIG_URL="https://raw.githubusercontent.com/ricardobevi/config/refs/heads/main/server/arch_test_try/user_configuration.json"
USER_CREDENTIALS_URL="https://raw.githubusercontent.com/ricardobevi/config/refs/heads/main/server/arch_test_try/user_credentials.json"

# Destination paths for the configuration files
CONFIG_DEST="/tmp/user_configuration.json"
CREDENTIALS_DEST="/tmp/user_credentials.json"

# Download the user configuration file
download_file "$USER_CONFIG_URL" "$CONFIG_DEST"

# Download the user credentials file
download_file "$USER_CREDENTIALS_URL" "$CREDENTIALS_DEST"

# Update system packages (optional, can be skipped if not needed)
echo "Updating system..."
sudo pacman -Syu --noconfirm

# Run archinstall with the downloaded configuration files
echo "Starting archinstall with provided configurations..."
archinstall --config "$CONFIG_DEST" --credentials "$CREDENTIALS_DEST"

echo "Installation process initiated. Follow the prompts to complete the installation."
