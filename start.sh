#!/bin/bash

command -v docker &>/dev/null || { echo "❌ Docker is not installed. Please install Docker and try again."; exit 1; }
pgrep -x "docker" &>/dev/null || { echo "❌ Docker is installed but not running. Please start Docker and try again."; exit 1; }
echo "✅ Docker is running. Continuing..."

git submodule update --init --recursive  # This clones the submodule if not already done

# Build and start Docker Compose services
echo "Building and starting Docker Compose services..."
docker compose up