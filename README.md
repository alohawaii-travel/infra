# 🌺 AlohaWaii Infrastructure

**Comprehensive Docker orchestration and development environment for the AlohaWaii tour platform.**

This repository provides the complete infrastructure layer that orchestrates the AlohaWaii microservices architecture, including the API backend and Staff Hub dashboard with multilingual support (English 🇺🇸, Korean 🇰🇷, Japanese 🇯🇵).

## 🚀 Quick Start

### Prerequisites
- Docker and Docker Compose
- Git

### One-Command Setup
```bash
# Clone the infrastructure repository
git clone <infrastructure-repository-url>
cd alohawaii-infrastructure

# Setup service repositories (update URLs in scripts/setup-services.sh first)
make setup-repos

# Initial setup (builds images, creates network and volumes)
make setup

# Start all services
make start-all
```

**🌐 Services Available:**
- **API**: http://localhost:4000 (Swagger docs at `/api/docs`)
- **Staff Hub**: http://localhost:3000 (Multilingual interface)
- **Database**: localhost:5432

## 🏗️ Architecture Overview

The platform consists of three main services orchestrated with Docker Compose:

| Service | Purpose | Port | Repository |
|---------|---------|------|------------|
| **alohawaii-api** | Next.js API server with Swagger docs | 4000 | Separate repo |
| **alohawaii-hub** | Staff management interface (multilingual) | 3000 | Separate repo |
| **alohawaii-db** | PostgreSQL 15 database | 5432 | Managed here |

All services run in the `alohawaii-network` for secure inter-service communication.

**📁 Repository Structure:**
```
alohawaii-infrastructure/     # This repo - Docker orchestration
├── ../api/                   # Cloned from alohawaii-api repo
├── ../hub/                   # Cloned from alohawaii-hub repo
├── scripts/                  # Automation and setup scripts
├── docs/                     # Additional documentation
├── docker-compose.yml        # Main orchestration
└── Makefile                  # Development commands
```

## 📋 Essential Commands

### 🔄 Daily Workflow
```bash
# Pull latest changes from all services
make update-repos

# Start development environment
make start-all

# View logs
make logs

# Check service status
make status

# Stop when done
make stop
```

### ⚙️ Setup Commands
```bash
make setup       # Initial setup (build images, create network)
make setup-repos # Clone API and Hub repositories
```

### 🚀 Service Management
```bash
make start       # Start API + Database
make start-all   # Start API + Hub + Database  
make start-api   # Start API + Database only
make start-hub   # Start Hub + API + Database
make stop        # Stop all services
make restart     # Restart all services
```

### 🔍 Monitoring & Debugging
```bash
make logs        # Show logs from all services
make logs-api    # Show API logs
make logs-hub    # Show Hub logs
make status      # Show service status
```

### 🛠️ Development Tools
```bash
make shell-api   # Open shell in API container
make shell-hub   # Open shell in Hub container
make test        # Run API tests (uses mocked database)
make migrate     # Run database migrations
make seed        # Seed database with sample data
```

### 💾 Database Operations
Database operations are now managed directly from the API directory.
See the `/api/prisma/README.md` for details on:
- Running migrations
- Pushing schema changes
- Seeding data
- Using Prisma Studio to browse and edit data

### 🧹 Maintenance
```bash
make clean       # Remove all containers and data
make rebuild     # Rebuild and restart everything
```

### 📦 Repository Management
```bash
make update-repos # Update API and Hub repositories
```

## 🐳 Docker Configuration

The setup uses multiple compose files for different environments:

- `docker-compose.yml`: Base configuration
- `docker-compose.override.yml`: Development overrides (auto-loaded)
- `docker-compose.prod.yml`: Production configuration

### Development Features
- **Hot Reload**: Code changes automatically trigger rebuilds
- **Volume Mounts**: Source code mounted for live editing
- **Debug Ports**: Node.js debugging enabled on port 9229
- **Database Persistence**: Data persists between container restarts

## 🚀 Development Workflow

### Daily Development
1. **Start the environment**: `make start-all`
2. **Make changes**: Edit code in `../api/` or `../hub/`
3. **View logs**: `make logs` to monitor all services
4. **Test changes**: Access services at the URLs above
5. **Stop when done**: `make stop`

### Team Collaboration
```bash
# Pull latest infrastructure changes
git pull origin main

# Update all service repositories
make update-repos

# Restart to pick up changes
make restart
```

## 🌟 Key Features

✅ **Multilingual Support** - Hub interface in English, Korean, and Japanese  
✅ **One-Command Setup** - `make setup` gets everything running  
✅ **Multi-Service Management** - API, Hub, and Database orchestration  
✅ **Repository Automation** - Scripts to manage separate API and Hub repositories  
✅ **Development Optimized** - Hot reloading, volume mounts, and debugging support  
✅ **Production Ready** - Production Docker configurations and deployment scripts  
✅ **Team Friendly** - Consistent development environment across all machines  

## 📚 Documentation

- **[Setup Guide](docs/SETUP.md)** - Detailed setup instructions and troubleshooting
- **[API Documentation](http://localhost:4000/api/docs)** - Swagger documentation (when API is running)
- **Makefile** - Run `make help` to see all available commands

## 🔧 Troubleshooting

### Common Issues

**Port conflicts**: If ports 3000, 4000, or 5432 are in use:
```bash
make stop
# Kill any conflicting processes
make start-all
```

**Services won't start**: Check Docker is running and has sufficient resources:
```bash
make status
make logs
```

**Database connection issues**:
```bash
make migrate
make seed
```

## 🤝 Contributing

1. Make changes to infrastructure in this repository
2. For API changes, work in the `../api/` directory
3. For Hub changes, work in the `../hub/` directory
4. Use `make` commands for consistent development workflow

## 📧 Support

For questions about the infrastructure setup, check the documentation in the `docs/` directory or review the Makefile commands with `make help`.
   make start-all
   ```

2. **Check status**:
   ```bash
   make status
   ```

3. **View logs** (if needed):
   ```bash
   make logs        # All services
   make logs-api    # API only
   make logs-hub    # Hub only
   ```

4. **Stop when done**:
   ```bash
   make stop
   ```

### Code Changes
- **API changes**: Edit files in `../api/src/` - changes auto-reload
- **Hub changes**: Edit files in `../hub/src/` - changes auto-reload
- **Database changes**: Use `make migrate` after schema updates

### Debugging
- **API debugging**: Available on port 9229
- **Container shell access**: `make shell-api` or `make shell-hub`
- **Database access**: Connect to localhost:5432

### Testing
```bash
make test        # Run API test suite
```

## 🔧 Troubleshooting

### Common Issues

#### Port Conflicts
If you get "port already in use" errors:
```bash
# Check what's using the ports
lsof -i :3000  # Hub port
lsof -i :4000  # API port
lsof -i :5432  # Database port

# Kill conflicting processes
kill <PID>
```

#### Container Issues
```bash
# View container status
make status

# Check logs for errors
make logs

# Restart services
make restart

# Complete reset
make clean
make setup
```

#### Database Connection Issues
```bash
# Check database health
make status

# View database logs
docker-compose logs db

# Reset database
make clean
make setup
```

#### Missing Service Directories
If you get errors about missing `api/` or `hub/` directories:
```bash
# Clone the service repositories (run from infra/ directory)
make setup-repos

# Or run the script directly
./scripts/setup-services.sh

# Make sure to update repository URLs in scripts/setup-services.sh first
```

#### Repository Update Issues
If `make update-repos` fails:
```bash
# Check if directories exist and are git repositories (from infra/ directory)
ls -la ../api/ ../hub/

# Manual update if needed
cd ../api && git pull origin main && cd ../infra
cd ../hub && git pull origin main && cd ../infra
```

### Advanced Docker Management

For advanced operations, use the `docker-manager.sh` script directly:

```bash
./docker-manager.sh help           # Show all available commands
./docker-manager.sh build api      # Build specific service
./docker-manager.sh shell api      # Shell into API container
./docker-manager.sh monitor        # Real-time monitoring
```

## 📚 API Documentation

The API includes interactive Swagger documentation:
- **Development**: http://localhost:4000/docs
- **Health Check**: http://localhost:4000/api/external/health

## 🔒 Environment Configuration

### Development Environment
Development settings are in `docker-compose.override.yml`:
- Hot reload enabled
- Debug ports exposed
- Source code mounted as volumes

### Production Deployment
Use the production configuration:
```bash
docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d
```

Production features:
- Optimized builds
- No development volumes
- Health checks enabled
- Restart policies configured

## 🤝 Contributing

1. **Setup development environment**:
   ```bash
   make setup
   make start-all
   ```

2. **Make changes** in the appropriate service directory

3. **Test changes**:
   ```bash
   make test
   ```

4. **Check logs** for any issues:
   ```bash
   make logs
   ```

5. **Submit pull request**

## 📜 Scripts Directory

The `/scripts` directory contains automation and utility scripts:

### Repository Management Scripts
- `setup-services.sh` - Clone API and Hub repositories (used by `make setup-repos`)
- `update-services.sh` - Pull latest changes from service repos (used by `make update-repos`)

### Usage
Repository management scripts are actively used and integrated into the Makefile workflow. Legacy development scripts can still be used but the Makefile commands provide better integration and error handling.

---

**Note**: This platform is in active development. The Docker-based development environment provides a consistent, isolated setup for all developers regardless of their local machine configuration.
