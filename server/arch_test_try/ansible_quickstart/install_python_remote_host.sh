#!/bin/bash

# Function to install Python on Debian-based systems (Ubuntu, etc.)
install_python_debian() {
  sudo apt update -y
  sudo apt install -y python3
}

# Function to install Python on Red Hat-based systems (CentOS, Fedora, RHEL)
install_python_redhat() {
  sudo yum install -y python3
}

# Function to install Python on Arch Linux systems
install_python_arch() {
  sudo pacman -Syu --noconfirm
  sudo pacman -S --noconfirm python
}

# Detect the OS type and call the corresponding function
if [ -f /etc/os-release ]; then
  . /etc/os-release
  case "$ID" in
    ubuntu|debian)
      install_python_debian
      ;;
    centos|fedora|rhel)
      install_python_redhat
      ;;
    arch)
      install_python_arch
      ;;
    *)
      echo "Unsupported Linux distribution: $ID"
      exit 1
      ;;
  esac
else
  echo "/etc/os-release not found. Unable to detect the OS."
  exit 1
fi

# Confirm Python installation by checking its version
if command -v python3 &> /dev/null; then
  python_version=$(python3 --version | awk '{print $2}')
  echo "Python installed successfully: Python $python_version"
else
  echo "Failed to install Python."
  exit 1
fi

exit 0
