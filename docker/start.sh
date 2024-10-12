#!/bin/bash

# Delete and clone Team-Portal repository
if [ -d "team-portal" ]; then
    echo "Deleting existing team-portal directory..."
    rm -rf "team-portal"
fi
echo "Cloning Team-Portal repository..."
git clone https://github.com/skcvolleybal/team-portal.git team-portal

# Delete and clone TC-App repository
if [ -d "tc-app" ]; then
    echo "Deleting existing tc-app directory..."
    rm -rf "tc-app"
fi
echo "Cloning TC-App repository..."
git clone https://github.com/skcvolleybal/tc-app.git tc-app

# Build and start Docker Compose services
echo "Building and starting Docker Compose services..."
docker-compose up --build -d
