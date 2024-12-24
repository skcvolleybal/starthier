#!/bin/bash

command -v docker &>/dev/null || { echo "❌ Docker is not installed. Please install Docker and try again."; exit 1; }

git submodule update --init --recursive  # This clones the submodule if not already done

# Build and start Docker Compose services
echo "Building and starting Docker Compose services..."
docker compose up