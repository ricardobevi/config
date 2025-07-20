#!/bin/bash

# Fixed virtual environment directory name
VENV_DIR=".venv"

if [ "$0" != "source" ]; then
    echo "WARNING: This script should be sourced, not executed. Please run 'source ./activate_venv.sh' instead of './activate_venv.sh'."
fi

if [ -d "$VENV_DIR/bin" ] && [ -f "$VENV_DIR/bin/activate" ]; then
    echo "Activating virtual environment at $VENV_DIR..."
    source "$VENV_DIR/bin/activate"
else
    echo "Virtual environment at $VENV_DIR does not exist." >&2
    exit 1
fi

echo "Virtual environment activated. You can now run Python commands within this shell."
