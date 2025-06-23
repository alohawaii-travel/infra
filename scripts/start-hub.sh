#!/bin/bash

echo "🛠️ Starting Alohawaii Staff Hub"
echo "==============================="

# Check if hub directory exists and has package.json
if [ ! -f "hub/package.json" ]; then
    echo "❌ Staff Hub application not found!"
    echo "Please ensure the hub directory exists with a package.json file."
    echo "For now, you can access:"
    echo "  - API: http://localhost:4000"
    echo "  - API Docs: http://localhost:4000/docs"
    exit 1
fi

# Start the hub service
echo "🚀 Starting staff hub dashboard..."
cd "$(dirname "$0")/.."
docker-compose -f hub/docker-compose.yml up --build

echo "🎉 Staff hub dashboard stopped."
