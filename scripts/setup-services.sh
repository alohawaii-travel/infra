#!/bin/bash

# Alohawaii Services Setup Script
# This script clones the API and Hub repositories into their respective directories

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration - Update these URLs with your actual GitHub repository URLs
API_REPO_URL="https://github.com/your-username/alohawaii-api.git"
HUB_REPO_URL="https://github.com/your-username/alohawaii-hub.git"

echo -e "${BLUE}🚀 Alohawaii Services Setup${NC}"
echo "This script will clone the API and Hub repositories"
echo

# Function to clone or update repository
clone_or_update_repo() {
    local repo_url=$1
    local directory=$2
    local service_name=$3
    
    if [ -d "$directory" ]; then
        echo -e "${YELLOW}📁 Directory $directory already exists${NC}"
        read -p "Do you want to update it? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            echo -e "${BLUE}🔄 Updating $service_name repository...${NC}"
            cd "$directory"
            git pull origin main
            cd ..
            echo -e "${GREEN}✅ $service_name updated successfully${NC}"
        else
            echo -e "${YELLOW}⏭️ Skipping $service_name update${NC}"
        fi
    else
        echo -e "${BLUE}📥 Cloning $service_name repository...${NC}"
        git clone "$repo_url" "../$directory"
        echo -e "${GREEN}✅ $service_name cloned successfully${NC}"
    fi
}

# Check if we're in the right directory
if [ ! -f "docker-compose.yml" ] || [ ! -f "Makefile" ]; then
    echo -e "${RED}❌ Error: This script must be run from the infra/ directory${NC}"
    echo "Please navigate to the infra/ directory containing docker-compose.yml and Makefile"
    exit 1
fi

echo -e "${BLUE}📋 Repository URLs:${NC}"
echo "API: $API_REPO_URL"
echo "Hub: $HUB_REPO_URL"
echo

# Confirm before proceeding
read -p "Do you want to proceed with cloning/updating? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}⏹️ Setup cancelled${NC}"
    exit 0
fi

# Clone or update repositories
echo -e "${BLUE}🔧 Setting up services...${NC}"
echo

clone_or_update_repo "$API_REPO_URL" "api" "API"
echo

clone_or_update_repo "$HUB_REPO_URL" "hub" "Hub"
echo

echo -e "${GREEN}🎉 Setup completed successfully!${NC}"
echo
echo -e "${BLUE}📖 Next steps:${NC}"
echo "1. Update repository URLs in this script if needed:"
echo "   - Edit scripts/setup-services.sh"
echo "   - Update API_REPO_URL and HUB_REPO_URL variables"
echo
echo "2. Start the development environment:"
echo "   make setup    # Initial setup"
echo "   make start-all # Start all services"
echo
echo "3. Check service status:"
echo "   make status"
echo "   make logs"
echo
echo -e "${GREEN}✨ Happy coding!${NC}"
