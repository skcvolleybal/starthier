#!/bin/bash

# Check if Docker is installed and running
command -v docker &>/dev/null || { echo "❌ Docker is not installed. Please install Docker and try again."; exit 1; }
pgrep -x "docker" &>/dev/null || { echo "❌ Docker is installed but not running. Please start Docker and try again."; exit 1; }
echo "✅ Docker is running. Continuing..."

# Exit immediately if a command exits with a non-zero status
set -e

git subtree add --prefix="team-portal" "https://github.com/skcvolleybal/team-portal.git" "master" 
git subtree add --prefix="tc-app" "https://github.com/skcvolleybal/tc-app.git" "master" 

echo "Subtrees added successfully."
# Build and start Docker Compose services
echo "Building and starting Docker Compose services..."
docker compose up