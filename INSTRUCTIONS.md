# AlohaWaii Project Context - Agent Notes

This document serves as my (GitHub Copilot's) ongoing reference for the AlohaWaii project. It contains context about the architecture, components, and development workflow that I need to remember as we continue building this project together. I will continuously update this document as we make changes to maintain a comprehensive understanding of the project state.

## Project Overview

AlohaWaii is a multi-service application consisting of:

- **API**: Backend service providing data and business logic
- **Hub**: Frontend administrative interface
- **Infra**: Infrastructure management and Docker configuration

## System Architecture

```
┌────────────────┐     ┌────────────────┐     ┌────────────────┐
│                │     │                │     │                │
│   Website(s)   │◄────►      API       │◄────►      Hub       │
│                │     │                │     │                │
└────────────────┘     └───────┬────────┘     └────────────────┘
                               │
                               ▼
                        ┌────────────────┐
                        │                │
                        │   Database     │
                        │                │
                        └────────────────┘
```

### Route Access
- **Website(s)**: Can access only external API routes (public-facing)
- **Hub**: Can access both internal and external API routes (admin access)
- **API**: Controls access via API keys and proper authentication

### Components

#### Website(s) (Frontend - Future)

- **Role**: Public-facing websites for customers
- **Access Level**: External API routes only
- **Authentication Methods**: Multiple OAuth providers
  - Google
  - Kakao
  - Apple
  - LINE
- **Purpose**: Customer-facing platform for tour information and bookings
- **Technology Stack**: Likely Next.js or similar frontend framework
- **Key Features**:
  - Public tour information display
  - Customer account management
  - Tour browsing and search
  - Reservation system
  - Payment processing
  - Multilingual support
- **API Authentication**: Uses WEBSITE_API_KEY for access

#### API (Backend)

- **Technology Stack**: Next.js with API routes
- **Port**: 4000
- **Key Features**:
  - RESTful API endpoints (both internal and external)
  - Authentication and authorization
  - Database operations via Prisma
  - Swagger API documentation
- **Environment Files**: 
  - `/api/.env.local` - Local development settings
  - `/api/.env.example` - Template for environment variables

#### Hub (Admin Frontend)

- **Technology Stack**: Next.js
- **Port**: 3000
- **Access Level**: Both internal and external API routes
- **Authentication Method**: Google OAuth with specific domain restrictions (staff only)
- **Purpose**: Administrative platform for staff and management
- **Key Features**:
  - Administrative interface
  - Staff user management
  - Customer management
  - Tour product management
  - Reservation management
  - Internationalization (i18n) with multiple language support
    - English (`en.json`)
    - Japanese (`ja.json`) 
    - Korean (`ko.json`)
- **Environment Files**:
  - `/hub/.env.local` - Local development settings
  - `/hub/.env.example` - Template for environment variables
- **API Authentication**: Uses HUB_API_KEY for access

#### Infrastructure (Infra)

- **Technology Stack**: Docker, Docker Compose
- **Key Files**:
  - `docker-compose.yml` - Main service definitions
  - `docker-compose.override.yml` - Development overrides
  - `docker-compose.prod.yml` - Production settings
  - `Makefile` - Development workflow commands
  - `docker-manager.sh` - Service management script
- **Environment Files**:
  - `/infra/.env` - Infrastructure environment variables
  - `/infra/.env.example` - Template for environment variables

#### Database

- **Type**: PostgreSQL
- **Port**: 5432 (externally accessible)
- **ORM**: Prisma
- **Schema**: Defined in `/api/prisma/schema.prisma`
- **Initialization**: SQL script in `/api/prisma/init.sql`
- **Username**: alohawaii_user
- **Database**: alohawaii_db

## Development Workflow

### Environment Setup

1. Run `make setup` from the `/infra` directory to:
   - Build Docker images
   - Create Docker network
   - Set up environment files
   - Generate secure secrets and API keys

2. Or run individual commands:
   - `make setup-env` - Configure environment files
   - `make update-vars` - Synchronize variables between API and Hub
   - `make gen-keys` - Generate new API keys

### Service Management

Start services with:
- `make start` - Start API and Database
- `make start-all` - Start API, Hub, and Database
- `make start-hub` - Start Hub with supporting services

Monitoring:
- `make status` - View service status
- `make logs` - View all logs
- `make logs-api` - View API logs
- `make logs-hub` - View Hub logs

### Common Tasks

- `make test` - Run API tests
- `make migrate` - Run database migrations
- `make seed` - Seed the database
- `make clean` - Remove all containers and data
- `make rebuild` - Rebuild and restart everything

## Security

- API keys are generated with strong entropy
- Database password is 32 characters long
- NextAuth secret is cryptographically secure
- All keys are unique to each installation
- API endpoints are protected by API keys
- Authentication is handled via OAuth:
  - Hub: Google OAuth with specific domain restrictions (staff only)
  - Website(s): Multiple OAuth providers (Google, Kakao, Apple, LINE)
- Role-based access control separates staff and customer access

## Shared Environment Variables

The following environment variables are synchronized across components:

| Variable | API | Hub | Infra |
|----------|-----|-----|-------|
| NEXTAUTH_SECRET | ✓ | ✓ | |
| HUB_API_KEY | ✓ | ✓ | |
| WEBSITE_API_KEY | ✓ | | |
| DEV_API_KEY | ✓ | | |
| DATABASE_URL | ✓ | | |
| POSTGRES_PASSWORD | | | ✓ |

## Database Connection

- **Internal Connection**: From API container to DB container
  - `postgresql://alohawaii_user:${password}@db:5432/alohawaii_db`

- **External Connection**: From host machine to DB container
  - `postgresql://alohawaii_user:${password}@localhost:5432/alohawaii_db`

- **Connection Tools**: 
  - DBeaver
  - psql
  - Any PostgreSQL client

## Context Tracking - For Agent Use

This section is specifically for me (GitHub Copilot) to track the context and state of the project as we build it together.

### Primary Project Goals
- Create a robust, maintainable infrastructure for a Next.js/Prisma/PostgreSQL application
- Ensure the database is accessible both inside Docker and externally via tools like DBeaver
- Maintain secure but easily manageable environment variables across services
- Provide a simplified developer experience through the Makefile interface

### Current Project State
- Basic infrastructure with Docker Compose is set up and working
- Environment management system is in place with script-based synchronization
- PostgreSQL database is correctly configured with proper user permissions
- Makefile has been simplified to remove redundancies
- DB is accessible externally on port 5432
- System architecture includes Website(s) with access to external routes only
- Hub has access to both internal and external API routes
- Authentication system is differentiated:
  - Hub: Google OAuth with domain restrictions (staff only)
  - Website(s): Multiple OAuth providers (Google, Kakao, Apple, LINE)
- Clear separation of purposes:
  - Hub: Administrative platform (staff, tour management, reservations)
  - Website(s): Customer-facing platform (bookings, account management)

### 2025-06-25: System Architecture and Environment Management

- Migrated `setup-environment.sh` script to `/infra/scripts/` directory
- Created `update-env-vars.sh` to synchronize variables between components
- Added new Makefile targets for environment management:
  - `setup-env`: Complete environment setup
  - `update-vars`: Sync environment variables
- Simplified Makefile service commands to reduce redundancy
- Added documentation in `/infra/docs/ENVIRONMENT.md`
- Fixed issue with the local PostgreSQL instance blocking Docker's port mapping
- Updated system architecture to include Website(s) component with external-only API access
- Clarified Hub's access to both internal and external API routes
- Documented authentication methods:
  - Hub: Google OAuth with domain restrictions for staff access
  - Website(s): Multiple OAuth providers (Google, Kakao, Apple, LINE) for customers
- Defined clear purposes for each component:
  - Hub: Administrative platform for staff (tour management, reservations)
  - Website(s): Customer-facing platform for tour information and bookings

### Port Configuration

- API: 4000
- Hub: 3000
- Database: 5432 (externally accessible)

### Known Issues

- When external PostgreSQL is running on port 5432, Docker port mapping may fail
- Solution: Stop local PostgreSQL (`brew services stop postgresql@14`) before starting Docker

### Key Files I Need to Remember

- `/infra/docker-compose.yml` - Main service definitions and port mappings
- `/infra/Makefile` - Simplified command interface for developers
- `/infra/docker-manager.sh` - Script handling the Docker commands
- `/infra/scripts/setup-environment.sh` - Sets up all environment files
- `/infra/scripts/update-env-vars.sh` - Synchronizes variables between services
- `/api/prisma/schema.prisma` - Database schema definition
- `/api/prisma/init.sql` - Initial database setup script, creates user and grants permissions
- `/hub/src/i18n.ts` - Internationalization configuration for the Hub
- `/api/src/middleware/apiAuth.ts` - Likely handles API key validation and route access control
- `/api/src/lib/auth.ts` - Authentication helpers for API access control
- `/api/src/lib/admin-auth.ts` - Admin authentication with Google OAuth domain restrictions
- `/hub/src/app/api/auth/[...nextauth]/route.ts` - NextAuth configuration for Hub
- `/api/src/app/api/auth/[...nextauth]/route.ts` - NextAuth configuration for API
- `/api/src/middleware.ts` - API middleware for route protection

### User's Environment

- OS: macOS
- Shell: zsh
- PostgreSQL: Local instance on version 14 (can cause port conflicts)
- Docker: Using Docker Desktop for Mac

### Current Conversation Focus

The current focus is on:
1. Simplifying and organizing the infrastructure for better maintainability
2. Ensuring proper environment variable management
3. Ensuring database accessibility both inside Docker and externally
4. Documenting the system for future reference

### Testing and Debugging Notes

#### DB Connection Issues
- Check `infra/.env` for correct password and port settings
- Ensure local PostgreSQL is not running (`brew services list`)
- Verify container status with `docker ps` and `docker logs alohawaii-db`
- Test connection: `psql -U alohawaii_user -h localhost -p 5432 alohawaii_db`
- If needed, connect to DB container: `docker exec -it alohawaii-db psql -U alohawaii_user -d alohawaii_db`

#### API Testing
- Health endpoint: `curl -H "X-API-Key: <DEV_API_KEY>" http://localhost:4000/api/health`
- Test suite: `make test`
- Look for test results in `/api/TEST_RESULTS_SUMMARY.md`

#### Environment Variable Debugging
- Check API env: `grep -v '^#' /Users/namkyu/Workspace/alohawaii/api/.env.local`
- Check Hub env: `grep -v '^#' /Users/namkyu/Workspace/alohawaii/hub/.env.local`
- Check Infra env: `grep -v '^#' /Users/namkyu/Workspace/alohawaii/infra/.env`
- Regenerate all variables: `make update-vars`

#### Common Commands I Should Use
- `make status` - Quick check of all service statuses
- `make logs-api` - View API logs for troubleshooting
- `cd /Users/namkyu/Workspace/alohawaii/infra && ls -la scripts/` - List available scripts
- `docker-compose config` - Validate and view the composed Docker configuration

---

*I will continuously update this document as we build the project to maintain context.*
