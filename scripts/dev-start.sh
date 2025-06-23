#!/bin/bash

echo "🌺 Starting Alohawaii Development Environment"
echo "============================================="

# Function to show help
show_help() {
    echo "Usage: $0 [OPTIONS] [SERVICE]"
    echo ""
    echo "OPTIONS:"
    echo "  -h, --help     Show this help message"
    echo "  --db-only      Start only the database"
    echo "  --api-only     Start only the API (requires database)"
    echo "  --hub-only     Start only the staff hub dashboard"
    echo ""
    echo "SERVICE:"
    echo "  all            Start all services (default)"
    echo "  db             Start database only"
    echo "  api            Start API and database"
    echo "  hub            Start staff hub dashboard"
    echo ""
    echo "Examples:"
    echo "  $0              # Start all services"
    echo "  $0 db           # Start database only"
    echo "  $0 api          # Start API with database"
    echo "  $0 --api-only   # Start API only (assumes DB running)"
}

# Parse arguments
SERVICE="all"
DB_ONLY=false
API_ONLY=false
HUB_ONLY=false

while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            show_help
            exit 0
            ;;
        --db-only)
            DB_ONLY=true
            shift
            ;;
        --api-only)
            API_ONLY=true
            shift
            ;;
        --hub-only)
            HUB_ONLY=true
            shift
            ;;
        db|api|hub|all)
            SERVICE=$1
            shift
            ;;
        *)
            echo "Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
done

# Check if .env.local exists for API
if [[ "$SERVICE" == "all" || "$SERVICE" == "api" || "$API_ONLY" == true ]]; then
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
fi

# Start services based on options
case $SERVICE in
    "db")
        echo "🗄️ Starting database only..."
        docker-compose -f api/docker-compose.yml up -d db
        ;;
    "api")
        echo "🚀 Starting API with database..."
        docker-compose -f api/docker-compose.yml up --build
        ;;
    "hub")
        echo "🛠️ Starting staff hub dashboard..."
        if [ ! -f "hub/package.json" ]; then
            echo "❌ Staff Hub application not found!"
            exit 1
        fi
        docker-compose -f hub/docker-compose.yml up --build
        ;;
    "all")
        if [[ "$DB_ONLY" == true ]]; then
            echo "🗄️ Starting database only..."
            docker-compose -f api/docker-compose.yml up -d db
        elif [[ "$API_ONLY" == true ]]; then
            echo "🚀 Starting API only..."
            docker-compose -f api/docker-compose.yml up --build api
        elif [[ "$HUB_ONLY" == true ]]; then
            echo "🛠️ Starting staff hub only..."
            if [ ! -f "hub/package.json" ]; then
                echo "❌ Staff Hub application not found!"
                exit 1
            fi
            docker-compose -f hub/docker-compose.yml up --build
        else
            echo "🚀 Starting all available services..."
            docker-compose -f api/docker-compose.yml up --build
            # TODO: Add hub when ready
            # docker-compose -f hub/docker-compose.yml up --build
        fi
        ;;
esac

echo "🎉 Development environment stopped."
