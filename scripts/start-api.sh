#!/bin/bash

echo "🌺 Starting Alohawaii API"
echo "========================="

# Check if .env.local exists
if [ ! -f "api/.env.local" ]; then
    echo "❌ api/.env.local not found!"
    echo "Please copy api/.env.example to api/.env.local and configure your environment variables."
    exit 1
fi

# Check for required environment variables
if ! grep -q "GOOGLE_CLIENT_ID=" api/.env.local || ! grep -q "GOOGLE_CLIENT_SECRET=" api/.env.local; then
    echo "⚠️  Google OAuth credentials not configured in api/.env.local"
    echo "Authentication will not work until you add:"
    echo "  GOOGLE_CLIENT_ID=your-google-client-id"
    echo "  GOOGLE_CLIENT_SECRET=your-google-client-secret"
    echo ""
    echo "Continue anyway? (y/N)"
    read -r response
    if [[ ! "$response" =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Start the API service
echo "🚀 Starting API service..."
cd "$(dirname "$0")/.."
docker-compose -f api/docker-compose.yml up --build

echo "🎉 API stopped."
