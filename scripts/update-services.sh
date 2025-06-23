#!/bin/bash

# Alohawaii Services Update Script
# This script pulls the latest changes from API and Hub repositories

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}🔄 Updating Alohawaii Services${NC}"
echo

# Function to update repository
update_service() {
    local directory=$1
    local service_name=$2
    
    if [ -d "../$directory" ]; then
        echo -e "${BLUE}📥 Updating $service_name...${NC}"
        cd "../$directory"
        git pull origin main
        cd ../infra
        echo -e "${GREEN}✅ $service_name updated${NC}"
    else
        echo -e "${RED}❌ $service_name directory not found. Run 'make setup-repos' first.${NC}"
    fi
}

# Check if we're in the right directory
if [ ! -f "docker-compose.yml" ]; then
    echo -e "${RED}❌ Error: Run this script from the infra/ directory${NC}"
    exit 1
fi

# Update services
update_service "api" "API"
update_service "hub" "Hub"

echo
echo -e "${GREEN}🎉 All services updated!${NC}"
echo -e "${BLUE}💡 Don't forget to restart services if needed:${NC}"
echo "   make restart-all"
