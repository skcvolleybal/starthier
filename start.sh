#!/bin/bash

# Check if Docker is installed and running
command -v docker &>/dev/null || { echo "❌ Docker is not installed. Please install Docker and try again."; exit 1; }
pgrep -x "docker" &>/dev/null || { echo "❌ Docker is installed but not running. Please start Docker and try again."; exit 1; }
echo "✅ Docker is running. Continuing..."

# Define repositories and their corresponding directories
REPOS=(
    "git@github.com:your-org/team-portal.git team-portal"
    "git@github.com:your-org/tc-app.git tc-app"
)

# Delete and reinitialize subtree directories
for REPO_PAIR in "${REPOS[@]}"; do
    REPO=$(echo "$REPO_PAIR" | awk '{print $1}')
    DIR=$(echo "$REPO_PAIR" | awk '{print $2}')
    
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