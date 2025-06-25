# Environment Management

This document describes how environment variables are managed across the Alohawaii project components.

## Overview

The Alohawaii project consists of several components that need to share certain environment variables:

- **API**: NextAuth secrets, API keys, database connection details
- **Hub**: NextAuth secrets, API keys, API URL
- **Infrastructure**: Database credentials, port mappings

## Environment Files

Each component has its own environment file:

- **API**: `/api/.env.local`
- **Hub**: `/hub/.env.local`
- **Infrastructure**: `/infra/.env`

## Setup and Synchronization

We provide several tools to manage environment variables:

### 1. Complete Environment Setup

Run the full environment setup script to:
- Generate secure random values for all secrets
- Create environment files from templates
- Update all environment variables
- Start Docker services

```bash
# From project root
cd infra
make setup-env
```

OR

```bash
# From infra directory
make setup
```

### 2. Update Environment Variables Only

If you need to synchronize environment variables between components without running the full setup:

```bash
# From infra directory
make update-vars
```

This will ensure that:
- `NEXTAUTH_SECRET` is the same in API and Hub
- `HUB_API_KEY` is consistent in both environments
- Database connection strings use the same credentials
- All API keys are properly set

### 3. Generate New API Keys

If you only need to update the API keys:

```bash
# From infra directory
make gen-keys
```

## Critical Environment Variables

The following environment variables are synchronized across components:

| Variable | API | Hub | Infra |
|----------|-----|-----|-------|
| NEXTAUTH_SECRET | ✓ | ✓ | |
| HUB_API_KEY | ✓ | ✓ | |
| WEBSITE_API_KEY | ✓ | | |
| DEV_API_KEY | ✓ | | |
| DATABASE_URL | ✓ | | |
| POSTGRES_PASSWORD | | | ✓ |

## Customizing Environment Variables

If you need to customize environment variables:

1. Edit the appropriate `.env` file directly
2. Run `make update-vars` to ensure consistency across components
3. Restart services with `make restart` for changes to take effect

## Troubleshooting

If you're experiencing issues with environment variables:

1. Check that all required `.env` files exist
2. Run `make update-vars` to synchronize variables
3. Verify that Docker containers can access the correct environment variables
4. Restart services with `make restart`

For more information, see the [Environment Setup](../ENVIRONMENT_SETUP.md) document.
