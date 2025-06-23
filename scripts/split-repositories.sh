#!/bin/bash

# Alohawaii Repository Split Script
# This script executes the commands from REPOSITORY_SETUP.md to split the project into three repositories

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}🌺 Alohawaii Repository Split Setup${NC}"
echo "This script will help you split the project into three GitHub repositories"
echo

# Configuration - User needs to update these
GITHUB_USERNAME="your-username"
INFRASTRUCTURE_REPO="alohawaii-infrastructure"
API_REPO="alohawaii-api" 
HUB_REPO="alohawaii-hub"

echo -e "${YELLOW}⚠️  IMPORTANT: Before running this script${NC}"
echo "1. Create three empty repositories on GitHub:"
echo "   - https://github.com/$GITHUB_USERNAME/$INFRASTRUCTURE_REPO"
echo "   - https://github.com/$GITHUB_USERNAME/$API_REPO"
echo "   - https://github.com/$GITHUB_USERNAME/$HUB_REPO"
echo
echo "2. Update the GITHUB_USERNAME variable in this script"
echo
echo "3. Make sure you're in the infra/ directory"
echo

# Check if we're in the right directory (should be in infra/)
if [ ! -f "docker-compose.yml" ] || [ ! -f "Makefile" ]; then
    echo -e "${RED}❌ Error: This script must be run from the infra/ directory${NC}"
    echo "Please navigate to the infra/ directory containing docker-compose.yml and Makefile"
    exit 1
fi

# Check if api and hub directories exist in parent directory
if [ ! -d "../api" ] || [ ! -d "../hub" ]; then
    echo -e "${RED}❌ Error: ../api/ or ../hub/ directories not found${NC}"
    echo "This script expects api/ and hub/ directories in the parent directory"
    exit 1
fi

# Confirm before proceeding
echo -e "${BLUE}This script will:${NC}"
echo "1. Initialize git in current directory (infrastructure)"
echo "2. Move api/ and hub/ to temporary locations"
echo "3. Commit and push infrastructure repository"
echo "4. Create and push API repository"
echo "5. Create and push Hub repository"
echo
read -p "Do you want to proceed? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}⏹️ Setup cancelled${NC}"
    exit 0
fi

echo -e "${BLUE}🔧 Step 1: Setting up Infrastructure Repository${NC}"

# Initialize git and backup service directories
echo "Initializing git repository..."
git init

echo "Moving api/ and hub/ directories to temporary locations..."
mv ../api ../../alohawaii-api-temp
mv ../hub ../../alohawaii-hub-temp

echo "Adding and committing infrastructure files..."
git add .
git commit -m "Initial commit: Alohawaii infrastructure setup

- Docker Compose configuration for multi-service architecture
- Makefile with simplified development commands
- Scripts for automated deployment and management
- Complete documentation and setup instructions"

echo "Adding GitHub remote and pushing..."
git remote add origin "https://github.com/$GITHUB_USERNAME/$INFRASTRUCTURE_REPO.git"
git branch -M main
git push -u origin main

echo -e "${GREEN}✅ Infrastructure repository created successfully${NC}"
echo

echo -e "${BLUE}🔧 Step 2: Setting up API Repository${NC}"

# Create API repository
mkdir "../../$API_REPO"
cd "../../$API_REPO"

echo "Moving API contents..."
mv ../alohawaii-api-temp/* .
mv ../alohawaii-api-temp/.* . 2>/dev/null || true
rmdir ../alohawaii-api-temp

echo "Initializing API repository..."
git init
git add .
git commit -m "Initial commit: Alohawaii API service

- Next.js API with TypeScript
- Prisma ORM with PostgreSQL integration
- NextAuth.js authentication system
- Comprehensive test suite with 100% coverage
- Swagger API documentation
- Docker containerization
- Health check endpoints"

echo "Adding GitHub remote and pushing..."
git remote add origin "https://github.com/$GITHUB_USERNAME/$API_REPO.git"
git branch -M main
git push -u origin main

echo -e "${GREEN}✅ API repository created successfully${NC}"
echo

echo -e "${BLUE}🔧 Step 3: Setting up Hub Repository${NC}"

# Create Hub repository
mkdir "../../$HUB_REPO"
cd "../../$HUB_REPO"

echo "Moving Hub contents..."
mv ../alohawaii-hub-temp/* .
mv ../alohawaii-hub-temp/.* . 2>/dev/null || true
rmdir ../alohawaii-hub-temp

echo "Initializing Hub repository..."
git init
git add .
git commit -m "Initial commit: Alohawaii Hub - Staff Management Interface

- Next.js admin dashboard with TypeScript
- Staff management and booking interface
- Authentication integration
- Modern UI components
- Docker containerization
- Development and production configurations"

echo "Adding GitHub remote and pushing..."
git remote add origin "https://github.com/$GITHUB_USERNAME/$HUB_REPO.git"
git branch -M main
git push -u origin main

echo -e "${GREEN}✅ Hub repository created successfully${NC}"
echo

# Go back to infrastructure directory
cd "../../$INFRASTRUCTURE_REPO"

echo -e "${GREEN}🎉 Repository split completed successfully!${NC}"
echo
echo -e "${BLUE}📋 Summary:${NC}"
echo "✅ Infrastructure: https://github.com/$GITHUB_USERNAME/$INFRASTRUCTURE_REPO"
echo "✅ API Service: https://github.com/$GITHUB_USERNAME/$API_REPO"
echo "✅ Hub Service: https://github.com/$GITHUB_USERNAME/$HUB_REPO"
echo
echo -e "${BLUE}📖 Next Steps:${NC}"
echo "1. Update repository URLs in scripts/setup-services.sh:"
echo "   - API_REPO_URL=\"https://github.com/$GITHUB_USERNAME/$API_REPO.git\""
echo "   - HUB_REPO_URL=\"https://github.com/$GITHUB_USERNAME/$HUB_REPO.git\""
echo
echo "2. Test the new setup:"
echo "   make setup-repos    # Clone service repositories"
echo "   make setup          # Setup Docker environment"
echo "   make start-all      # Start all services"
echo
echo -e "${GREEN}✨ Your repositories are ready for team development!${NC}"
