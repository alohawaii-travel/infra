#!/bin/bash

# Alohawaii Docker Management Script
# Provides simple commands to manage the entire stack

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Functions
print_header() {
    echo -e "${BLUE}🌺 Alohawaii Docker Manager${NC}"
    echo -e "${BLUE}=============================${NC}"
}

print_success() {
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

check_docker() {
    if ! command -v docker &> /dev/null; then
        print_error "Docker is not installed"
        exit 1
    fi
    
    if ! docker info &> /dev/null; then
        print_error "Docker daemon is not running"
        exit 1
    fi
}

show_help() {
    print_header
    echo ""
    echo "Usage: $0 <command>"
    echo ""
    echo "Commands:"
    echo "  setup           Initial setup - build all images"
    echo "  start           Start default services (API + Database)"
    echo "  start-all       Start all services (API + Hub + Database)"
    echo "  start-db        Start Database only"
    echo "  start-hub       Start Hub with supporting services"
    echo "  stop            Stop all services"
    echo "  restart         Restart all services"
    echo "  logs            Show logs for all services"
    echo "  logs-api        Show API logs"
    echo "  logs-hub        Show Hub logs"
    echo "  logs-db         Show Database logs"
    echo "  status          Show status of all services"
    echo "  clean           Remove all containers and volumes"
    echo "  rebuild         Rebuild and restart all services"
    echo "  shell-api       Open shell in API container"
    echo "  shell-hub       Open shell in Hub container"
    echo "  shell-db        Open shell in Database container"
    echo "  test            Run API tests (uses mocked database)"
    echo "  migrate         Run database migrations"
    echo "  seed            Seed database with initial data"
    echo ""
    echo "Examples:"
    echo "  $0 setup        # First time setup"
    echo "  $0 start        # Start API development"
    echo "  $0 start-all    # Start everything including Hub"
    echo "  $0 logs-api     # Watch API logs"
}

setup() {
    print_header
    print_info "Setting up Alohawaii development environment..."
    
    check_docker
    
    # Check environment files
    if [ ! -f "../api/.env.local" ]; then
        print_warning "../api/.env.local not found, copying from example..."
        cp ../api/.env.example ../api/.env.local 2>/dev/null || print_warning "../api/.env.example not found"
    fi
    
    if [ ! -f "../hub/.env.local" ]; then
        print_warning "../hub/.env.local not found, copying from example..."
        cp ../hub/.env.example ../hub/.env.local 2>/dev/null || print_warning "../hub/.env.example not found"
    fi
    
    # Create network
    docker network create alohawaii-network 2>/dev/null || print_info "Network already exists"
    
    # Build images
    print_info "Building Docker images..."
    docker-compose build
    
    # Ask if environment variables should be synchronized
    read -p "Do you want to synchronize environment variables between API and Hub? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        print_info "Synchronizing environment variables..."
        cd scripts && ./update-env-vars.sh && cd ..
    else
        print_info "Skipping environment variable synchronization"
    fi
    
    print_success "Setup complete!"
    print_info "You can now run: $0 start"
}

start_services() {
    local profile="$1"
    check_docker
    
    if [ "$profile" = "all" ]; then
        print_info "Starting all services (API + Hub + Database)..."
        docker-compose --profile hub up -d
    elif [ "$profile" = "hub" ]; then
        print_info "Starting Hub + API + Database..."
        docker-compose --profile hub up -d
    elif [ "$profile" = "api" ]; then
        print_info "Starting API + Database..."
        docker-compose up -d api
    elif [ "$profile" = "db" ]; then
        print_info "Starting Database only..."
        docker-compose up -d db
    else
        print_info "Starting default services (API + Database)..."
        docker-compose up -d api
    fi
    
    print_success "Services started!"
    print_info "API: http://localhost:4000"
    print_info "Hub: http://localhost:3000 (if started)"
    print_info "Database: postgresql://user:password@localhost:5432/alohawaii_db"
}

stop_services() {
    check_docker
    print_info "Stopping all services..."
    docker-compose down
    print_success "Services stopped!"
}

show_logs() {
    local service="$1"
    check_docker
    
    if [ -z "$service" ]; then
        docker-compose logs -f
    else
        docker-compose logs -f "$service"
    fi
}

show_status() {
    check_docker
    print_header
    docker-compose ps
    echo ""
    print_info "Network status:"
    docker network ls | grep alohawaii || print_warning "Network not found"
}

clean_all() {
    check_docker
    print_warning "This will remove all containers, volumes, and data!"
    read -p "Are you sure? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        print_info "Cleaning up..."
        docker-compose down -v --remove-orphans
        docker network rm alohawaii-network 2>/dev/null || true
        print_success "Cleanup complete!"
    else
        print_info "Cleanup cancelled"
    fi
}

rebuild_all() {
    check_docker
    print_info "Rebuilding all services..."
    docker-compose down
    docker-compose build --no-cache
    docker-compose up -d
    print_success "Rebuild complete!"
}

open_shell() {
    local service="$1"
    check_docker
    
    if ! docker-compose ps "$service" | grep -q "Up"; then
        print_error "Service $service is not running"
        exit 1
    fi
    
    print_info "Opening shell in $service container..."
    docker-compose exec "$service" /bin/sh
}

run_tests() {
    check_docker
    print_info "Running API tests with mocked database..."
    docker-compose exec api npm test
}

run_migrations() {
    check_docker
    print_info "Running database migrations..."
    docker-compose exec api npm run db:migrate
}

seed_database() {
    check_docker
    print_info "Seeding database..."
    docker-compose exec api npm run db:seed
}

# Main command handling
case "$1" in
    setup)
        setup
        ;;
    start)
        start_services "api"
        ;;
    start-all)
        start_services "all"
        ;;
    start-api)
        start_services "api"
        ;;
    start-db)
        start_services "db"
        ;;
    start-hub)
        start_services "hub"
        ;;
    stop)
        stop_services
        ;;
    restart)
        stop_services
        start_services "api"
        ;;
    logs)
        show_logs
        ;;
    logs-api)
        show_logs "api"
        ;;
    logs-hub)
        show_logs "hub"
        ;;
    logs-db)
        show_logs "db"
        ;;
    status)
        show_status
        ;;
    clean)
        clean_all
        ;;
    rebuild)
        rebuild_all
        ;;
    shell-api)
        open_shell "api"
        ;;
    shell-hub)
        open_shell "hub"
        ;;
    shell-db)
        open_shell "db"
        ;;
    test)
        run_tests
        ;;
    migrate)
        run_migrations
        ;;
    seed)
        seed_database
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        print_error "Unknown command: $1"
        echo ""
        show_help
        exit 1
        ;;
esac
