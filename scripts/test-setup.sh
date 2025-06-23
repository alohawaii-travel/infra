#!/bin/bash

echo "🧪 Testing Alohawaii API Setup"
echo "================================"

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker is not running. Please start Docker and try again."
    exit 1
fi

echo "✅ Docker is running"

# Test TypeScript compilation
echo "🔍 Testing TypeScript compilation..."
cd /Users/namkyu/Workspace/alohawaii/api
if npm run type-check; then
    echo "✅ TypeScript compilation successful"
else
    echo "❌ TypeScript compilation failed"
    exit 1
fi

# Check if we can build the API container
echo "🔨 Testing API container build..."
cd /Users/namkyu/Workspace/alohawaii
if docker-compose -f api/docker-compose.yml build api; then
    echo "✅ API container builds successfully"
else
    echo "❌ Failed to build API container"
    exit 1
fi

# Start the database
echo "🗄️ Testing database startup..."
if docker-compose -f api/docker-compose.yml up -d db; then
    echo "✅ Database started"
else
    echo "❌ Failed to start database"
    exit 1
fi

# Wait for database to be ready
echo "⏳ Waiting for database to be ready..."
sleep 10

# Check database health
if docker-compose -f api/docker-compose.yml exec db pg_isready -U user -d alohawaii_dev; then
    echo "✅ Database is healthy"
else
    echo "❌ Database is not ready"
    exit 1
fi

# Clean up
echo "🧹 Cleaning up test environment..."
docker-compose -f api/docker-compose.yml down

echo ""
echo "🎉 All tests passed! Setup is working correctly."
echo ""
echo "Next steps:"
echo "1. Add your Google OAuth credentials to api/.env.local:"
echo "   GOOGLE_CLIENT_ID=\"your-google-client-id\""
echo "   GOOGLE_CLIENT_SECRET=\"your-google-client-secret\""
echo ""
echo "2. Start development environment:"
echo "   ./scripts/dev-start.sh api"
echo ""
echo "3. Access your API:"
echo "   - Homepage: http://localhost:4000"
echo "   - API Docs: http://localhost:4000/docs"
echo "   - Health Check: http://localhost:4000/api/external/health"
echo ""
