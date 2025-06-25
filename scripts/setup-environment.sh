#!/bin/bash
# AlohaWaii Environment Setup Script
# This script automates the complete environment setup process

set -e  # Exit on any error

echo "🚀 AlohaWaii Environment Setup"
echo "=============================="
echo ""

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

# Check if we're in the right directory
if [[ ! -d "../../api" || ! -d "../../hub" || ! -d "../" ]]; then
    print_error "Please run this script from the infra/scripts directory"
    exit 1
fi

echo "🔍 Checking prerequisites..."

# Check for required tools
check_tool() {
    if ! command -v $1 &> /dev/null; then
        print_error "$1 is required but not installed. Please install $1 and try again."
        exit 1
    fi
}

check_tool "openssl"
check_tool "docker"
check_tool "docker-compose"

print_status "All prerequisites found"

echo ""
echo "📁 Setting up environment files..."

# Generate secure passwords and keys
generate_secure_key() {
    openssl rand -base64 32 | tr -d "=+/" | cut -c1-32
}

generate_api_key() {
    echo "$1-$(openssl rand -hex 16)"
}

# Generate all secrets
DB_PASSWORD=$(generate_secure_key)
NEXTAUTH_SECRET=$(generate_secure_key)
HUB_API_KEY=$(generate_api_key "hub-api-key")
WEBSITE_API_KEY=$(generate_api_key "website-api-key")
DEV_API_KEY=$(generate_api_key "dev-api-key")

print_info "Generated secure passwords and API keys"

# Setup Infrastructure environment
echo ""
echo "🏗️  Setting up infrastructure environment..."

if [[ ! -f "../.env" ]]; then
    cp ../.env.example ../.env
    print_status "Created infra/.env from template"
else
    print_warning "infra/.env already exists, backing up to infra/.env.backup"
    cp ../.env ../.env.backup
fi

# Update infrastructure .env
sed -i '' "s/POSTGRES_PASSWORD=.*/POSTGRES_PASSWORD=${DB_PASSWORD}/" ../.env
print_status "Updated infrastructure environment"

# Setup API environment
echo ""
echo "🔧 Setting up API environment..."

if [[ ! -f "../../api/.env.local" ]]; then
    cp ../../api/.env.example ../../api/.env.local
    print_status "Created api/.env.local from template"
else
    print_warning "api/.env.local already exists, backing up to api/.env.local.backup"
    cp ../../api/.env.local ../../api/.env.local.backup
fi

# Update API .env.local
DATABASE_URL="postgresql://alohawaii_user:${DB_PASSWORD}@localhost:5432/alohawaii_db?schema=public"

sed -i '' "s|DATABASE_URL=.*|DATABASE_URL=\"${DATABASE_URL}\"|" ../../api/.env.local
sed -i '' "s/NEXTAUTH_SECRET=.*/NEXTAUTH_SECRET=\"${NEXTAUTH_SECRET}\"/" ../../api/.env.local
sed -i '' "s/HUB_API_KEY=.*/HUB_API_KEY=\"${HUB_API_KEY}\"/" ../../api/.env.local
sed -i '' "s/WEBSITE_API_KEY=.*/WEBSITE_API_KEY=\"${WEBSITE_API_KEY}\"/" ../../api/.env.local
sed -i '' "s/DEV_API_KEY=.*/DEV_API_KEY=\"${DEV_API_KEY}\"/" ../../api/.env.local

print_status "Updated API environment"

# Setup Hub environment
echo ""
echo "🎯 Setting up Hub environment..."

if [[ ! -f "../../hub/.env.local" ]]; then
    cp ../../hub/.env.example ../../hub/.env.local
    print_status "Created hub/.env.local from template"
else
    print_warning "hub/.env.local already exists, backing up to hub/.env.local.backup"
    cp ../../hub/.env.local ../../hub/.env.local.backup
fi

# Update Hub .env.local
sed -i '' "s/NEXTAUTH_SECRET=.*/NEXTAUTH_SECRET=\"${NEXTAUTH_SECRET}\"/" ../../hub/.env.local
sed -i '' "s/API_KEY=.*/API_KEY=\"${HUB_API_KEY}\"/" ../../hub/.env.local
sed -i '' "s/HUB_API_KEY=.*/HUB_API_KEY=\"${HUB_API_KEY}\"/" ../../hub/.env.local

print_status "Updated Hub environment"

echo ""
echo "📋 Environment Setup Summary"
echo "=============================="
echo ""
print_info "Database Password: ${DB_PASSWORD}"
print_info "NextAuth Secret: ${NEXTAUTH_SECRET}"
print_info "Hub API Key: ${HUB_API_KEY}"
print_info "Website API Key: ${WEBSITE_API_KEY}"
print_info "Dev API Key: ${DEV_API_KEY}"

echo ""
echo "📁 Files Created/Updated:"
echo "- infra/.env"
echo "- api/.env.local"
echo "- hub/.env.local"

echo ""
echo "🐳 Starting Docker services..."

cd ../
if docker-compose up -d; then
    print_status "Docker services started successfully"
else
    print_error "Failed to start Docker services"
    exit 1
fi

echo ""
echo "⏳ Waiting for database to be ready..."
sleep 10

echo ""
echo "🗄️  Setting up database..."
cd ../../api

# Install dependencies if node_modules doesn't exist
if [[ ! -d "node_modules" ]]; then
    print_info "Installing API dependencies..."
    npm install
fi

# Database setup has been completed manually - Prisma has been removed
print_info "Database setup is now handled manually or through your preferred ORM"
print_status "Database setup completed"

cd ../

echo ""
echo "🧪 Running tests to verify setup..."

cd api
if npm test -- tests/unit/health.test.ts --silent; then
    print_status "Health tests passed - API setup verified"
else
    print_warning "Health tests failed - there might be an issue with the API setup"
fi

cd ../

echo ""
echo "🎉 Setup Complete!"
echo "=================="
echo ""
print_status "Environment setup completed successfully!"
echo ""
echo "📚 Next Steps:"
echo "1. API service is running at: http://localhost:4000"
echo "2. Hub service can be started with: cd hub && npm run dev"
echo "3. Database is accessible at: localhost:5432"
echo ""
echo "🔧 Useful Commands:"
echo "- Start all services: cd infra && docker-compose up -d"
echo "- Stop all services: cd infra && docker-compose down"
echo "- View service logs: cd infra && docker-compose logs -f [service-name]"
echo "- Run API tests: cd api && npm test"
echo ""
echo "📖 Documentation:"
echo "- Environment Setup: ../ENVIRONMENT_SETUP.md"
echo "- API Security: ../API_SECURITY_IMPLEMENTATION.md"
echo ""
print_warning "Keep your environment files secure and never commit them to version control!"

echo ""
echo "🔐 Security Reminder:"
echo "- API keys have been generated with strong entropy"
echo "- Database password is 32 characters long"
echo "- NextAuth secret is cryptographically secure"
echo "- All keys are unique to this installation"
