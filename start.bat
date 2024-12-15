@echo off

REM Delete and clone Team-Portal repository
IF EXIST "team-portal" (
    echo Deleting existing team-portal directory...
    rmdir /S /Q "team-portal"
)

REM Delete and clone TC-App repository
IF EXIST "tc-app" (
    echo Deleting existing tc-app directory...
    rmdir /S /Q "tc-app"
)
git submodule update --init --recursive

REM Build and start Docker Compose services
echo Building and starting Docker Compose services...
docker compose up