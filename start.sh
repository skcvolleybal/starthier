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

# Delete and clone TC-App repository
if [ -d "tc-app" ]; then
    echo "Deleting existing tc-app directory..."
    rm -rf "tc-app"
    echo "Existing Team-Portal removed"
fi

git submodule update --init --recursive


# Build and start Docker Compose services
echo "Building and starting Docker Compose services..."
docker compose up