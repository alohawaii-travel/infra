#!/bin/bash

echo "🗄️ Starting Alohawaii Database"
echo "==============================="

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker is not running. Please start Docker and try again."
    exit 1
fi

echo "✅ Docker is running"

# Start just the database
echo "🚀 Starting PostgreSQL database..."
cd "$(dirname "$0")/.."
docker-compose -f api/docker-compose.yml up -d db

# Wait for database to be ready
echo "⏳ Waiting for database to be ready..."
sleep 5

# Check database health
if docker-compose -f api/docker-compose.yml exec db pg_isready -U user -d alohawaii_db; then
    echo "✅ Database is ready at postgresql://user:password@localhost:5432/alohawaii_db"
else
    echo "❌ Database failed to start properly"
    exit 1
fi

echo ""
echo "🎉 Database started successfully!"
echo ""
echo "To stop: docker-compose -f api/docker-compose.yml down"
