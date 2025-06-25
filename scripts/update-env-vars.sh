#!/bin/bash
# AlohaWaii Environment Variables Update Script
# This script updates environment variables across Hub and API projects

set -e  # Exit on any error

echo "🔄 AlohaWaii Environment Variables Update"
echo "========================================"
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

# Check for required files
if [[ ! -f "../../api/.env.local" ]]; then
    print_error "API environment file not found: ../../api/.env.local"
    print_info "Run setup-environment.sh first to create all environment files"
    exit 1
fi

if [[ ! -f "../../hub/.env.local" ]]; then
    print_error "Hub environment file not found: ../../hub/.env.local"
    print_info "Run setup-environment.sh first to create all environment files"
    exit 1
fi

if [[ ! -f "../.env" ]]; then
    print_error "Infrastructure environment file not found: ../.env"
    print_info "Run setup-environment.sh first to create all environment files"
    exit 1
fi

print_status "All prerequisite files found"
echo ""

# Function to get a variable from a file
get_var() {
    local file=$1
    local var_name=$2
    local value=$(grep "^$var_name=" "$file" | cut -d= -f2- | tr -d '"')
    echo "$value"
}

# Function to update a variable in a file
update_var() {
    local file=$1
    local var_name=$2
    local var_value=$3
    
    if grep -q "^$var_name=" "$file"; then
        sed -i '' "s|^$var_name=.*|$var_name=\"$var_value\"|" "$file"
        print_status "Updated $var_name in $file"
    else
        echo "$var_name=\"$var_value\"" >> "$file"
        print_status "Added $var_name to $file"
    fi
}

echo "📋 Synchronizing environment variables..."

# Get critical variables from API environment
API_ENV="../../api/.env.local"
HUB_ENV="../../hub/.env.local"
INFRA_ENV="../.env"

# Extract variables from API .env.local
NEXTAUTH_SECRET=$(get_var "$API_ENV" "NEXTAUTH_SECRET")
HUB_API_KEY=$(get_var "$API_ENV" "HUB_API_KEY")
WEBSITE_API_KEY=$(get_var "$API_ENV" "WEBSITE_API_KEY")
DEV_API_KEY=$(get_var "$API_ENV" "DEV_API_KEY")

# Extract database password from infrastructure .env
DB_PASSWORD=$(get_var "$INFRA_ENV" "POSTGRES_PASSWORD")

# If any key variables are empty, generate new ones
if [[ -z "$NEXTAUTH_SECRET" ]]; then
    print_warning "NEXTAUTH_SECRET not found, generating new one"
    NEXTAUTH_SECRET=$(openssl rand -base64 32 | tr -d "=+/" | cut -c1-32)
fi

if [[ -z "$HUB_API_KEY" ]]; then
    print_warning "HUB_API_KEY not found, generating new one"
    HUB_API_KEY="hub-api-key-$(openssl rand -hex 16)"
fi

if [[ -z "$WEBSITE_API_KEY" ]]; then
    print_warning "WEBSITE_API_KEY not found, generating new one"
    WEBSITE_API_KEY="website-api-key-$(openssl rand -hex 16)"
fi

if [[ -z "$DEV_API_KEY" ]]; then
    print_warning "DEV_API_KEY not found, generating new one"
    DEV_API_KEY="dev-api-key-$(openssl rand -hex 16)"
fi

if [[ -z "$DB_PASSWORD" ]]; then
    print_warning "DB_PASSWORD not found, generating new one"
    DB_PASSWORD=$(openssl rand -base64 32 | tr -d "=+/" | cut -c1-32)
    update_var "$INFRA_ENV" "POSTGRES_PASSWORD" "$DB_PASSWORD"
fi

echo ""
echo "⚙️ Updating API environment..."
# Update API environment variables
DATABASE_URL="postgresql://alohawaii_user:${DB_PASSWORD}@localhost:5432/alohawaii_db?schema=public"
update_var "$API_ENV" "DATABASE_URL" "$DATABASE_URL"
update_var "$API_ENV" "NEXTAUTH_SECRET" "$NEXTAUTH_SECRET"
update_var "$API_ENV" "HUB_API_KEY" "$HUB_API_KEY"
update_var "$API_ENV" "WEBSITE_API_KEY" "$WEBSITE_API_KEY"
update_var "$API_ENV" "DEV_API_KEY" "$DEV_API_KEY"

echo ""
echo "⚙️ Updating Hub environment..."
# Update Hub environment variables
update_var "$HUB_ENV" "NEXTAUTH_SECRET" "$NEXTAUTH_SECRET"
update_var "$HUB_ENV" "HUB_API_KEY" "$HUB_API_KEY"
update_var "$HUB_ENV" "API_URL" "http://localhost:4000"

echo ""
echo "📋 Environment Variables Sync Summary"
echo "==================================="
print_info "Environment variables updated successfully!"
print_info "The following variables are now synchronized:"
echo "- NEXTAUTH_SECRET (API and Hub)"
echo "- HUB_API_KEY (API and Hub)"
echo "- WEBSITE_API_KEY (API)"
echo "- DEV_API_KEY (API)"
echo "- Database connection settings"
echo ""

print_warning "Remember to restart your services for the changes to take effect:"
echo "- make restart"
