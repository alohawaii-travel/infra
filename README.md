# Alohawaii Tour Platform - Infrastructure

A comprehensive Docker-based development environment for the Alohawaii tour platform, featuring orchestration for API, Hub, and database services.

## 🏗️ Repository Structure

This repository contains the infrastructure and orchestration for the Alohawaii platform. The actual services are maintained in separate GitHub repositories:

- **API Service**: `alohawaii-api` - Backend API with Next.js and Prisma
- **Hub Service**: `alohawaii-hub` - Staff management interface  
- **Infrastructure**: `alohawaii-infrastructure` - This repository (Docker orchestration)

## 🌺 Quick Start

### Prerequisites
- Docker and Docker Compose
- Git

### Initial Setup
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

The platform will be available at:
- **API**: http://localhost:4000
- **Staff Hub**: http://localhost:3000  
- **Database**: localhost:5432

## 🐳 Docker Development Environment

### Architecture Overview
The platform consists of three main services orchestrated with Docker Compose:

- **API Service** (`alohawaii-api`): Next.js API server on port 4000 - *Separate repository*
- **Hub Service** (`alohawaii-hub`): Staff management interface on port 3000 - *Separate repository*
- **Database Service** (`alohawaii-db`): PostgreSQL 15 on port 5432 - *Managed by this infrastructure*

All services run in the `alohawaii-network` for secure inter-service communication.

**Note**: The API and Hub services are maintained in separate repositories. Use `make setup-repos` to clone them into the correct directories.

### Available Commands

#### Setup Commands
```bash
make setup       # Initial setup (build images, create network)
```

#### Service Management
```bash
make start       # Start API + Database
make start-all   # Start API + Hub + Database  
make start-api   # Start API + Database only
make start-hub   # Start Hub + API + Database
make stop        # Stop all services
make restart     # Restart all services
```

#### Monitoring & Debugging
```bash
make logs        # Show logs from all services
make logs-api    # Show API logs
make logs-hub    # Show Hub logs
make status      # Show service status
```

#### Development Tools
```bash
make shell-api   # Open shell in API container
make shell-hub   # Open shell in Hub container
make test        # Run API tests
make migrate     # Run database migrations
make seed        # Seed database with sample data
```

#### Maintenance
```bash
make clean       # Remove all containers and data
make rebuild     # Rebuild and restart everything
```

#### Repository Management
```bash
make setup-repos  # Clone API and Hub repositories
make update-repos # Update API and Hub repositories
```

### Docker Compose Configuration

The setup uses multiple compose files for different environments:

- `docker-compose.yml`: Base configuration
- `docker-compose.override.yml`: Development overrides (auto-loaded)
- `docker-compose.prod.yml`: Production configuration
- `docker-compose.test.yml`: Testing environment

#### Development Features
- **Hot Reload**: Code changes automatically trigger rebuilds
- **Volume Mounts**: Source code mounted for live editing
- **Debug Ports**: Node.js debugging enabled on port 9229
- **Database Persistence**: Data persists between container restarts

#### Environment Variables
Development environment variables are automatically loaded from:
- `.env.local` (highest priority)
- `.env`

### Health Checks & Monitoring

All services include health checks for reliable startup:

```bash
# Check service status
make status

# API health endpoint
curl http://localhost:4000/api/external/health

# View container logs
make logs-api
make logs-hub
```

## 📁 Project Structure

### Root Directory
```
alohawaii/
├── infra/                  # Infrastructure repository (this directory)
│   ├── scripts/           # Automation and repository management scripts
│   ├── docker-compose.yml # Main compose configuration
│   ├── docker-compose.*.yml # Environment-specific configs
│   ├── docker-manager.sh  # Advanced Docker management
│   └── Makefile          # Simplified commands
├── api/                   # API service (separate repository)
└── hub/                   # Staff Hub service (separate repository)
```

### API Service (`../api`)
```
../api/
├── src/
│   ├── app/               # Next.js 13+ app directory
│   ├── components/        # Reusable components
│   ├── lib/              # Utilities and configuration
│   └── types/            # TypeScript definitions
├── prisma/               # Database schema and migrations
├── tests/                # Test suites
├── Dockerfile           # API container configuration
└── package.json         # Dependencies and scripts
```

### Hub Service (`../hub`)
```
../hub/
├── src/
│   ├── app/              # Next.js 13+ app directory
│   ├── components/       # UI components
│   └── lib/             # Utilities
├── Dockerfile           # Hub container configuration
└── package.json         # Dependencies and scripts
```

## 🚀 Development Workflow

### Daily Development
1. **Start the environment**:
   ```bash
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

### Legacy Development Scripts
These scripts are maintained for compatibility but Docker commands are preferred:
- `dev-start.sh` → Use `make start-all` instead
- `start-api.sh` → Use `make start-api` instead  
- `start-hub.sh` → Use `make start-hub` instead
- `start-db.sh` → Included in `make start` instead
- `test-setup.sh` → Use `make test` instead

### Usage
Repository management scripts are actively used and integrated into the Makefile workflow. Legacy development scripts can still be used but the Makefile commands provide better integration and error handling.

---

**Note**: This platform is in active development. The Docker-based development environment provides a consistent, isolated setup for all developers regardless of their local machine configuration.
