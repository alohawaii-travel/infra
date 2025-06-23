# 🛠️ AlohaWaii Infrastructure - Setup Guide

This guide provides detailed setup instructions for the AlohaWaii development environment.

## 📋 Prerequisites

### Required Software
- **Docker Desktop** (latest version)
- **Git** (2.0 or later)
- **Node.js** (18 or later) - for local development outside containers

### System Requirements
- **RAM**: 4GB minimum, 8GB recommended
- **Storage**: 2GB free space for Docker images
- **Network**: Internet connection for downloading dependencies

## 🚀 Quick Setup (New Developers)

```bash
# 1. Clone infrastructure repository
git clone https://github.com/your-username/alohawaii-infrastructure.git
cd alohawaii-infrastructure

# 2. Update repository URLs in scripts/setup-services.sh
# Edit the API_REPO_URL and HUB_REPO_URL variables
nano scripts/setup-services.sh

# 3. Setup service repositories
make setup-repos

# 4. Initial Docker setup
make setup

# 5. Start all services
make start-all

# 6. Verify everything is working
make status
```

**🌐 Access Services:**
- **API**: http://localhost:4000 (Swagger docs at `/api/docs`)
- **Staff Hub**: http://localhost:3000
- **Database**: localhost:5432

## 📂 Repository Structure After Setup

```
alohawaii/
├── infra/                    # This repository
│   ├── scripts/             # Automation scripts
│   ├── docs/               # Documentation
│   ├── docker-compose.yml  # Main orchestration
│   └── Makefile            # Commands
├── api/                     # API service (cloned)
└── hub/                     # Hub service (cloned)
```

## 🔧 Manual Setup (Alternative)

If you prefer to understand each step:

### Step 1: Clone Infrastructure
```bash
git clone https://github.com/your-username/alohawaii-infrastructure.git
cd alohawaii-infrastructure
```

### Step 2: Configure Repository URLs
Edit `scripts/setup-services.sh` and update:
```bash
API_REPO_URL="https://github.com/your-username/alohawaii-api.git"
HUB_REPO_URL="https://github.com/your-username/alohawaii-hub.git"
```

### Step 3: Clone Service Repositories
```bash
./scripts/setup-services.sh
```

### Step 4: Initialize Docker Environment
```bash
# Create Docker network and volumes
docker network create alohawaii-network 2>/dev/null || true
docker volume create alohawaii-db-data 2>/dev/null || true

# Build all images
docker-compose build
```

### Step 5: Start Services
```bash
# Start all services
docker-compose --profile hub up -d

# Or start individually
docker-compose up -d alohawaii-db
docker-compose up -d alohawaii-api
docker-compose --profile hub up -d alohawaii-hub
```

## 🐳 Docker Environment Details

### Compose Profiles
The setup uses Docker Compose profiles for flexible service management:

- **Default profile**: API + Database
- **Hub profile**: All services including Hub

### Environment Files
Environment variables are loaded from:
1. `.env.local` (highest priority, git-ignored)
2. `.env` (default values, committed)

### Volume Mounts
Development setup includes volume mounts for hot reloading:
- `../api:/app` - API source code
- `../hub:/app` - Hub source code
- `alohawaii-db-data:/var/lib/postgresql/data` - Database persistence

### Network Configuration
All services communicate through the `alohawaii-network` bridge network:
- **alohawaii-db**: Internal hostname for database
- **alohawaii-api**: Internal hostname for API
- **alohawaii-hub**: Internal hostname for Hub

## 🔍 Verification & Testing

### Health Checks
```bash
# Check all services are running
make status

# Test API health endpoint
curl http://localhost:4000/api/external/health

# Test Hub accessibility
curl -I http://localhost:3000

# Test database connection
make shell-api
# Inside container: npm run db:status
```

### View Logs
```bash
# All services
make logs

# Individual services
make logs-api
make logs-hub
make logs-db
```

### Test Database
```bash
# Run migrations
make migrate

# Seed test data
make seed

# Open database shell
make shell-db
```

## 🔄 Repository Management

### Initial Clone
The `make setup-repos` command clones the API and Hub repositories as siblings to the infrastructure directory.

### Updates
```bash
# Pull latest changes from all repositories
make update-repos

# This runs:
# - git pull in infrastructure
# - git pull in ../api
# - git pull in ../hub
```

### Working with Separate Repositories
Each service repository maintains its own:
- Git history
- Dependencies
- Docker configuration
- Documentation

## 🚨 Troubleshooting

### Port Conflicts
If you get port binding errors:
```bash
# Check what's using the ports
lsof -i :3000
lsof -i :4000
lsof -i :5432

# Stop conflicting services
make stop

# Kill any remaining processes
docker-compose down --remove-orphans
```

### Docker Issues
```bash
# Clean up Docker resources
make clean

# Reset everything
docker system prune -a --volumes

# Rebuild from scratch
make setup
make start-all
```

### Database Connection Issues
```bash
# Reset database
make clean
make setup
make migrate
make seed
```

### Service Not Starting
```bash
# Check logs for specific service
make logs-api
make logs-hub

# Restart specific service
docker-compose restart alohawaii-api
docker-compose restart alohawaii-hub
```

### Hot Reload Not Working
Verify volume mounts:
```bash
# Check if source code is mounted correctly
make shell-api
ls -la /app  # Should show your API source code

make shell-hub
ls -la /app  # Should show your Hub source code
```

## 🎯 Advanced Configuration

### Custom Environment Variables
Create `.env.local` in the infrastructure directory:
```bash
# Database
POSTGRES_PASSWORD=your-secure-password

# API
API_SECRET=your-api-secret
NEXTAUTH_SECRET=your-nextauth-secret

# Hub
HUB_API_URL=http://alohawaii-api:4000
```

### Production Setup
For production deployment:
```bash
# Use production compose file
docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d
```

### Testing Environment
For running tests:
```bash
# Use test environment
docker-compose -f docker-compose.yml -f docker-compose.test.yml up -d

# Run tests
make test
```

## 📚 Next Steps

After successful setup:

1. **Explore the API**: Visit http://localhost:4000/api/docs for Swagger documentation
2. **Access the Hub**: Go to http://localhost:3000 and sign in with Google
3. **Review the Code**: Check out the API and Hub repositories
4. **Read Documentation**: Each service has its own README with specific details
5. **Start Development**: Make changes and see them reflected in real-time

## 🤝 Team Collaboration

### New Team Member Setup
1. Clone infrastructure repository
2. Update repository URLs in setup script
3. Run `make setup-repos && make setup && make start-all`
4. Share `.env.local` securely with team members

### Daily Workflow
1. `make update-repos` - Get latest changes
2. `make start-all` - Start development environment
3. Make changes in `../api/` or `../hub/`
4. `make logs` - Monitor for issues
5. `make stop` - Stop when done

### Branch Management
Each repository (infra, api, hub) maintains separate branches:
- Work on features in separate repositories
- Coordinate infrastructure changes through this repository
- Use `make update-repos` to sync all repositories
