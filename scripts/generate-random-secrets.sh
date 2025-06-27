#!/bin/bash
# Alohawaii Environment Variables Update Script
# This script updates environment variables across Hub and API projects

set -e  # Exit on any error

echo "🔄 Alohawaii Environment Variables Update"
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

# Generate secure passwords and keys
generate_secure_key() {
    openssl rand -base64 32 | tr -d "=+/" | cut -c1-32
}

generate_api_key() {
    echo "$1-$(openssl rand -hex 16)"
}
cd .. 
# Check if we're in the right directory
if [[ ! -d "./../api" || ! -d "./../hub" ]]; then
    echo "Not in infra directory: ../api or ../hub not found."
    print_error "Please run this script from the infra directory (it should be infra)"
    exit 1
else
    echo "In infra directory: ../api and ../hub found."
fi

print_status "All prerequisite files found"
echo ""

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

# Set dirs
API_ENV="../api/.env.local"
HUB_ENV="../hub/.env.local"
INFRA_ENV=".env"

# Create values
DB_NAME="alohawaii_db"
DB_USER="alohawaii_user"
DB_HOST="localhost"
DB_PORT="5432"
DB_SCHEMA="public"
DB_PASSWORD="db-$(generate_secure_key)"
NEXTAUTH_SECRET="ns-$(generate_secure_key)"
HUB_API_KEY="hub-api-key-$(generate_api_key)"
WEBSITE_API_KEY="website-api-key-$(generate_api_key)"
DEV_API_KEY="dev-api-key-$(generate_api_key)"

echo ""
echo "⚙️ Updating Infra environment..."
update_var "$INFRA_ENV" "DB_NAME" "$DB_NAME"
update_var "$INFRA_ENV" "DB_HOST" "$DB_HOST"
update_var "$INFRA_ENV" "DB_PORT" "$DB_PORT"
update_var "$INFRA_ENV" "DB_USER" "$DB_USER"
update_var "$INFRA_ENV" "DB_PASSWORD" "$DB_PASSWORD"
update_var "$INFRA_ENV" "DB_SCHEMA" "$DB_SCHEMA"
update_var "$INFRA_ENV" "NEXTAUTH_SECRET" "$NEXTAUTH_SECRET"
update_var "$INFRA_ENV" "HUB_API_KEY" "$HUB_API_KEY"
update_var "$INFRA_ENV" "WEBSITE_API_KEY" "$WEBSITE_API_KEY"
update_var "$INFRA_ENV" "DEV_API_KEY" "$DEV_API_KEY"

print_warning "Remember to restart your services for the changes to take effect:"
echo "- make restart"
