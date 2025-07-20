#!/bin/bash

# Fixed virtual environment directory name
VENV_DIR=".venv"
REQUIREMENTS_FILE="requirements.txt"

# Function to check if a virtual environment exists
venv_exists() {
    if [ -d "$1/bin" ] && [ -f "$1/bin/python" ] && [ -f "$1/bin/activate" ]; then
        return 0
    else
        return 1
    fi
}

# Check for --delete-venv option
DELETE_VENV=false
if [[ $@ == *--delete-venv* ]]; then
    DELETE_VENV=true
fi

# Check if the virtual environment already exists
if venv_exists "$VENV_DIR"; then
    echo "Virtual environment at $VENV_DIR found."

    if [ "$DELETE_VENV" = true ]; then
        echo "Deleting existing virtual environment..."
        rm -rf "$VENV_DIR"
        # Create a new virtual environment
        python3 -m venv "$VENV_DIR"
        if [ $? -ne 0 ]; then
            echo "Failed to create virtual environment at $VENV_DIR." >&2
            exit 1
        fi
    else
        echo "Skipping deletion of existing virtual environment."
    fi
else
    # Create a new virtual environment
    python3 -m venv "$VENV_DIR"
    if [ $? -ne 0 ]; then
        echo "Failed to create virtual environment at $VENV_DIR." >&2
        exit 1
    fi
fi

# Activate the virtual environment and install requirements
source "$VENV_DIR/bin/activate"

pip install --upgrade pip
if [ -f "$REQUIREMENTS_FILE" ]; then
    pip3 install -r "$REQUIREMENTS_FILE"
    if [ $? -eq 0 ]; then
        echo "Requirements from $REQUIREMENTS_FILE installed successfully."
    else
        echo "Failed to install requirements." >&2
        deactivate
        exit 1
    fi
else
    echo "$REQUIREMENTS_FILE not found. Skipping installation of requirements."
fi

deactivate

exit 0
