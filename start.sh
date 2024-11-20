#!/bin/bash

command -v docker &>/dev/null || { echo "❌ Docker is not installed. Please install Docker and try again."; exit 1; }
pgrep -x "docker" &>/dev/null || { echo "❌ Docker is installed but not running. Please start Docker and try again."; exit 1; }
echo "✅ Docker is running. Continuing..."


# Delete and clone Team-Portal repository
if [ -d "team-portal" ]; then
    echo "Deleting existing team-portal directory..."
    rm -rf "team-portal"
    echo "Existing Team-Portal removed"
fi
echo "Cloning Team-Portal repository..."
git clone https://github.com/skcvolleybal/team-portal.git team-portal
echo "✅ Team-Portal freshly cloned"

# Delete and clone TC-App repository
if [ -d "tc-app" ]; then
    echo "Deleting existing tc-app directory..."
    rm -rf "tc-app"
    echo "Existing Team-Portal removed"
fi
echo "Cloning TC-App repository..."
git clone https://github.com/skcvolleybal/tc-app.git tc-app
echo "✅ TC-app freshly cloned"


# Build and start Docker Compose services
echo "Building and starting Docker Compose services..."
docker compose up --build 
