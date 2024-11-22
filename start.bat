@echo off

REM Delete and clone Team-Portal repository
IF EXIST "team-portal" (
    echo Deleting existing team-portal directory...
    rmdir /S /Q "team-portal"
)
echo Cloning Team-Portal repository...
git clone https://github.com/skcvolleybal/team-portal.git team-portal

REM Delete and clone TC-App repository
IF EXIST "tc-app" (
    echo Deleting existing tc-app directory...
    rmdir /S /Q "tc-app"
)
echo Cloning TC-App repository...
git clone https://github.com/skcvolleybal/tc-app.git tc-app

REM Build and start Docker Compose services
echo Building and starting Docker Compose services...
docker compose up