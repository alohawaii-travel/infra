#!/bin/bash
# filepath: /Users/namkyu/Workspace/alohawaii/infra/scripts/generate-api-keys.sh

# Generate secure API keys for development
echo "🔐 Generating secure API keys for AlohaWaii services..."

# Function to generate a secure random key
generate_key() {
    openssl rand -hex 32
}

# Generate keys
HUB_KEY=$(generate_key)
WEBSITE_KEY=$(generate_key)
DEV_KEY=$(generate_key)

echo ""
echo "✅ Generated API keys:"
echo ""
echo "🏢 Hub API Key:     $HUB_KEY"
echo "🌐 Website API Key: $WEBSITE_KEY"
echo "🔧 Dev API Key:     $DEV_KEY"
echo ""
echo "📝 Add these to your environment files:"
echo ""
echo "API (.env):"
echo "HUB_API_KEY=$HUB_KEY"
echo "WEBSITE_API_KEY=$WEBSITE_KEY"
echo "DEV_API_KEY=$DEV_KEY"
echo ""
echo "Hub (.env):"
echo "HUB_API_KEY=$HUB_KEY"
echo ""
echo "Website (.env):"
echo "WEBSITE_API_KEY=$WEBSITE_KEY"
echo ""
echo "⚠️  Keep these keys secure and never commit them to version control!"
