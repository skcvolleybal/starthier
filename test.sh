#!/bin/bash

# Define the line to be added
LINE="export PATH=/Applications/XAMPP/xamppfiles/bin:\$PATH"

# Check if the line already exists in .zshrc
if ! grep -Fxq "$LINE" ~/.zshrc; then
    # If not, add the line
    echo "$LINE" >> ~/.zshrc
    echo "Line added to .zshrc"
else
    echo "Line already exists in .zshrc"
fi
