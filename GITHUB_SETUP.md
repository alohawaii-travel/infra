# 🌺 Alohawaii Infrastructure - GitHub Repository Description

## Repository Information for GitHub

**Repository Name**: `alohawaii-infrastructure`

**Short Description**: 
Docker orchestration and development environment for Alohawaii tour platform - manages API and Hub services with comprehensive automation scripts.

**Detailed Description**:

```markdown
# 🌺 Alohawaii Infrastructure

**Comprehensive Docker orchestration and development environment for the Alohawaii tour platform.**

This repository provides the complete infrastructure layer that orchestrates the Alohawaii microservices architecture, including the API backend and Staff Hub dashboard.

## 🏗️ What This Repository Contains

- **Docker Compose Configuration** - Multi-service orchestration for development and production
- **Makefile Commands** - Simplified development workflow with one-command setup
- **Automation Scripts** - Repository management, service updates, and deployment utilities
- **Development Environment** - Complete local development setup with hot reloading
- **Documentation** - Comprehensive guides for setup, deployment, and team collaboration

## 🚀 Key Features

✅ **One-Command Setup** - `make setup` gets everything running  
✅ **Multi-Service Management** - API, Hub, and Database orchestration  
✅ **Repository Automation** - Scripts to manage separate API and Hub repositories  
✅ **Development Optimized** - Hot reloading, volume mounts, and debugging support  
✅ **Production Ready** - Production Docker configurations and deployment scripts  
✅ **Team Friendly** - Consistent development environment across all machines  

## 🛠️ Quick Start

```bash
# Clone and setup
git clone https://github.com/your-username/alohawaii-infrastructure.git
cd alohawaii-infrastructure
make setup

# Start all services
make start-all

# Access services
# API: http://localhost:4000
# Hub: http://localhost:3000
# Database: localhost:5432
```

## 📋 Service Architecture

- **alohawaii-api**: Next.js backend with authentication and Swagger docs
- **alohawaii-hub**: Staff management dashboard with Google OAuth
- **PostgreSQL**: Database with automated migrations and health checks

## 🎯 For Teams

This infrastructure repository enables teams to work independently on API and Hub services while maintaining consistent development environments. Perfect for microservices development with proper separation of concerns.

**Related Repositories:**
- [alohawaii-api](https://github.com/your-username/alohawaii-api) - Backend API service
- [alohawaii-hub](https://github.com/your-username/alohawaii-hub) - Staff management interface
```

## GitHub Project Settings

**Visibility**: Private (recommended for business projects)

**Topics/Tags**: 
`docker`, `infrastructure`, `microservices`, `nextjs`, `postgresql`, `makefile`, `devops`, `tour-platform`, `nodejs`, `typescript`

**Topics**:
- Infrastructure as Code
- Docker Compose
- Microservices Orchestration
- Development Environment
- Tour Management Platform

**Project Avatar**: Consider using 🌺 emoji or a palm tree/Hawaii-themed icon

## Commands to Set Up on GitHub

1. **Create the repositories on GitHub**:
   - `alohawaii-infrastructure`
   - `alohawaii-api`
   - `alohawaii-hub`

2. **Update the script with your GitHub username**:
   ```bash
   nano scripts/split-repositories.sh
   # Change: GITHUB_USERNAME="your-actual-username"
   ```

3. **Run the automated split**:
   ```bash
   make split-repos
   ```

This will handle all the git initialization, repository creation, and pushing to GitHub automatically!
