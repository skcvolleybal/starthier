#!/bin/bash

# Check if Docker is installed and running
command -v docker &>/dev/null || { echo "❌ Docker is not installed. Please install Docker and try again."; exit 1; }
pgrep -x "docker" &>/dev/null || { echo "❌ Docker is installed but not running. Please start Docker and try again."; exit 1; }
echo "✅ Docker is running. Continuing..."

# Define repositories and prefixes
declare -A REPOS=(
    ["team-portal"]="git@github.com:your-org/team-portal.git"
    ["tc-app"]="git@github.com:your-org/tc-app.git"
)

# Delete and reinitialize subtree directories
for DIR in "${!REPOS[@]}"; do
    REPO="${REPOS[$DIR]}"
    
    if [ -d "$DIR" ]; then
        echo "Deleting existing $DIR directory..."
        rm -rf "$DIR"
        echo "Existing $DIR removed"
    fi
    
    echo "Reinitializing $DIR as a subtree..."
    git subtree add --prefix="$DIR" "$REPO" main --squash
done

# Build and start Docker Compose services
echo "Building and starting Docker Compose services..."
docker compose up