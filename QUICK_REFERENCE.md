# Alohawaii - Quick Reference

## 🚀 New Developer Setup

```bash
# 1. Clone infrastructure repo
git clone https://github.com/your-username/alohawaii-infrastructure.git
cd alohawaii-infrastructure

# 2. Update repository URLs in scripts/setup-services.sh
# Edit the API_REPO_URL and HUB_REPO_URL variables

# 3. Setup service repositories
make setup-repos

# 4. Initial Docker setup
make setup

# 5. Start all services
make start-all
```

## 📂 Repository Structure

```
alohawaii-infrastructure/     # This repo - Docker orchestration
├── ../api/                   # Cloned from alohawaii-api
├── ../hub/                   # Cloned from alohawaii-hub
├── scripts/
│   ├── setup-services.sh    # Clone service repos
│   └── update-services.sh   # Update service repos
├── docker-compose.yml       # Main orchestration
├── Makefile                 # Development commands
└── README.md                # Documentation
```

## 🔄 Daily Workflow

```bash
# Pull latest changes from all services
make update-repos

# Start development environment
make start-all

# View logs
make logs

# Check status
make status

# Stop when done
make stop
```

## 📋 Essential Commands

| Command | Description |
|---------|-------------|
| `make setup-repos` | Clone API and Hub repositories |
| `make update-repos` | Pull latest changes from service repos |
| `make setup` | Initial Docker setup |
| `make start-all` | Start all services |
| `make status` | Check service status |
| `make logs` | View all logs |
| `make stop` | Stop all services |
| `make clean` | Remove all containers and data |

## 🌐 Service URLs

- **API**: http://localhost:4000
- **Hub**: http://localhost:3000
- **Database**: localhost:5432

## 📖 Important Files

- `scripts/setup-services.sh` - Update repository URLs here
- `docker-compose.yml` - Main service configuration
- `Makefile` - All available commands
- `REPOSITORY_SETUP.md` - Detailed setup instructions
