# Alohawaii Project - Repository Organization Plan

## Repository Structure

This project will be split into three separate GitHub repositories:

### 1. `alohawaii-api` 📚
**Purpose**: Backend API service built with Next.js and Prisma
**Contents**: 
- `/api/` directory contents
- API documentation
- Database schema and migrations
- Authentication logic
- Testing suite

**GitHub URL**: `https://github.com/your-username/alohawaii-api`

### 2. `alohawaii-hub` 🏢
**Purpose**: Staff management interface and admin dashboard
**Contents**:
- `/hub/` directory contents  
- Admin interface
- Dashboard components
- Staff management features

**GitHub URL**: `https://github.com/your-username/alohawaii-hub`

### 3. `alohawaii-infrastructure` 🐳
**Purpose**: Docker orchestration and development environment
**Contents**:
- Docker Compose files
- Makefile for simplified commands
- Shell scripts for automation
- Development documentation
- Environment configuration

**GitHub URL**: `https://github.com/your-username/alohawaii-infrastructure`

## Repository Setup Commands

### Option 1: Automated Setup (Recommended)

Use the provided script to automate the entire process:

```bash
# 1. Update the GITHUB_USERNAME in the script
nano scripts/split-repositories.sh

# 2. Create three empty repositories on GitHub first, then run:
make split-repos
```

### Option 2: Manual Setup

If you prefer to run the commands manually:

### Step 1: Create Infrastructure Repository
```bash
# Navigate to project root
cd /Users/namkyu/Workspace/alohawaii

# Initialize git and remove api/hub directories temporarily
git init
mv api ../alohawaii-api-temp
mv hub ../alohawaii-hub-temp

# Add and commit infrastructure files
git add .
git commit -m "Initial commit: Alohawaii infrastructure setup

- Docker Compose configuration for multi-service architecture
- Makefile with simplified development commands
- Scripts for automated deployment and management
- Complete documentation and setup instructions"

# Add GitHub remote (replace with your actual GitHub URL)
git remote add origin https://github.com/your-username/alohawaii-infrastructure.git
git push -u origin main
```

### Step 2: Create API Repository
```bash
# Create new directory for API
mkdir /Users/namkyu/Workspace/alohawaii-api
cd /Users/namkyu/Workspace/alohawaii-api

# Move API contents back
mv ../alohawaii-api-temp/* .
mv ../alohawaii-api-temp/.* . 2>/dev/null || true
rmdir ../alohawaii-api-temp

# Initialize git
git init
git add .
git commit -m "Initial commit: Alohawaii API service

- Next.js API with TypeScript
- Prisma ORM with PostgreSQL integration
- NextAuth.js authentication system
- Comprehensive test suite with 100% coverage
- Swagger API documentation
- Docker containerization
- Health check endpoints"

# Add GitHub remote
git remote add origin https://github.com/your-username/alohawaii-api.git
git push -u origin main
```

### Step 3: Create Hub Repository
```bash
# Create new directory for Hub
mkdir /Users/namkyu/Workspace/alohawaii-hub
cd /Users/namkyu/Workspace/alohawaii-hub

# Move Hub contents back
mv ../alohawaii-hub-temp/* .
mv ../alohawaii-hub-temp/.* . 2>/dev/null || true
rmdir ../alohawaii-hub-temp

# Initialize git
git init
git add .
git commit -m "Initial commit: Alohawaii Hub - Staff Management Interface

- Next.js admin dashboard with TypeScript
- Staff management and booking interface
- Authentication integration
- Modern UI components
- Docker containerization
- Development and production configurations"

# Add GitHub remote
git remote add origin https://github.com/your-username/alohawaii-hub.git
git push -u origin main
```

## Development Workflow

After splitting into repositories, developers can:

1. **Clone infrastructure repo first**:
   ```bash
   git clone https://github.com/your-username/alohawaii-infrastructure.git
   cd alohawaii-infrastructure
   ```

2. **Setup service repositories using the provided script**:
   ```bash
   # Update repository URLs in scripts/setup-services.sh first
   make setup-repos
   # or run directly: ./scripts/setup-services.sh
   ```

3. **Use existing Makefile commands**:
   ```bash
   make setup     # Initial setup
   make start-all # Start all services
   make logs      # View logs
   make status    # Check service status
   ```

4. **Keep services updated**:
   ```bash
   make update-repos  # Pull latest changes from API and Hub repos
   # or run directly: ./scripts/update-services.sh
   ```

## Repository Management Scripts

The infrastructure repository includes helper scripts for managing the service repositories:

### `scripts/setup-services.sh`
- Clones the API and Hub repositories into the correct directories
- Can update existing repositories if they already exist
- Interactive prompts for confirmation
- Accessible via `make setup-repos`

### `scripts/update-services.sh`  
- Pulls the latest changes from both service repositories
- Quick way to sync all services
- Accessible via `make update-repos`

**Important**: Update the repository URLs in `scripts/setup-services.sh` with your actual GitHub repository URLs before running.

## Benefits of This Structure

✅ **Separation of Concerns**: Each service has its own repository and can be developed independently
✅ **Team Collaboration**: Different teams can work on API vs Hub without conflicts
✅ **CI/CD**: Each service can have its own deployment pipeline
✅ **Version Control**: Services can be versioned and released independently
✅ **Security**: Different access permissions for different repositories
✅ **Scalability**: Easy to add new services in the future

## Next Steps

1. Create the GitHub repositories on your GitHub account
2. Run the setup commands above
3. Update Docker Compose files to reference the new structure if needed
4. Set up CI/CD pipelines for each repository
5. Configure branch protection and merge request policies
