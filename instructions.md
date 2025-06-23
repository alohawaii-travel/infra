# 🧭 Project Instructions: Tour Website with Admin Tool, API, and Cloned Sites

This project powers a tour platform with:
- 🛠️ A **Staff Hub** for managing products, users, and reservations
- 🔌 An **API** that handles both internal (hub) and external (website) requests
- 🌐 **Cloned Websites** for different marketing regions

We use **Docker**, **Kubernetes**, and **GitHub Copilot** for development and deployment.

---

## 📁 Monorepo Structure

```
/
├── instructions.md              # Project documentation
├── README.md                   # Main documentation
├── docker-compose.yml          # Legacy - use individual service compose files
├── api/                        # Next.js API with Swagger docs
│   ├── docker-compose.yml     # API + Database
│   ├── Dockerfile
│   ├── package.json
│   ├── prisma/                 # Database schema & migrations
│   └── src/                   # TypeScript source code
├── hub/                       # Staff management dashboard
│   └── docker-compose.yml     # Hub service
├── web/                       # Future static websites
├── docker/                    # Shared Dockerfiles
├── k8s/                       # Kubernetes manifests
├── infra/                     # Helm charts, secrets
└── scripts/                   # Development utilities
    ├── dev-start.sh           # Multi-service startup
    ├── start-api.sh           # API only
    ├── start-hub.sh           # Hub only
    ├── start-db.sh            # Database only
    └── test-setup.sh          # Validate setup
```

---

## ⚙️ Technologies

| Layer         | Tech                                |
|---------------|-------------------------------------|
| Frontend      | React, Next.js, or Vue              |
| Backend       | Node.js, Express or NestJS          |
| DB            | PostgreSQL (with Prisma ORM)        |
| Auth          | JWT or 3rd-party (Auth0/Firebase)   |
| DevOps        | Docker, Kubernetes, Helm            |
| CI/CD         | GitHub Actions                      |
| Hosting       | GKE, EKS, or DigitalOcean Kubernetes|

---

## 🚀 Dev Setup (Docker Compose)

Each service has its own Docker Compose file for microservices architecture.

```bash
# Start all services
./scripts/dev-start.sh

# Start individual services
./scripts/dev-start.sh api       # API + Database
./scripts/dev-start.sh db        # Database only
./scripts/dev-start.sh hub       # Staff hub dashboard

# Alternative individual commands
./scripts/start-api.sh           # API with database
./scripts/start-db.sh            # Database only
./scripts/start-hub.sh           # Hub only
```

**First Time Setup:**
1. Copy environment variables: `cp api/.env.example api/.env.local`
2. Configure Google OAuth credentials in `api/.env.local`
3. Start services: `./scripts/dev-start.sh api`
4. Run database migrations: `docker-compose -f api/docker-compose.yml exec api npm run db:migrate`
5. Seed initial data: `docker-compose -f api/docker-compose.yml exec api npm run db:seed`

Services:
- `hub` → http://localhost:3000 - Staff management dashboard
- `api` → http://localhost:4000
- `api docs` → http://localhost:4000/docs
- `db` → PostgreSQL on port 5432

**Test Setup:**
```bash
./scripts/test-setup.sh
```

---

## ☸️ Kubernetes Setup

### Minikube (local)

```bash
minikube start
kubectl apply -f k8s/dev/
```

### Helm (optional)

```bash
cd infra/
helm install tour-app ./chart --namespace tour --create-namespace
```

---

## 📐 Conventions

- All services follow this naming: `app-[service-name]`
- Docker image tags are versioned: `app-api:v1.0.0`
- Use `.env` files for local env vars
- Store secrets in Kubernetes secrets or use SealedSecrets

---

## ✍️ Notes for GitHub Copilot

- Prioritize RESTful route design
- Auto-generate Prisma types from schema
- Suggest strongly typed DTOs in API
- Scaffold CRUD endpoints with input validation
- Prefer reusable UI components in `hub`
- Use Tailwind or Material UI if relevant

---

## 🧪 Testing

- Use `Jest` for backend unit tests
- Use `Playwright` or `Cypress` for frontend E2E
- CI runs tests on every PR via GitHub Actions

---

## 🗃️ Database

Using PostgreSQL with Prisma

```bash
npx prisma migrate dev --name init
npx prisma studio
```

---

## 🛣️ Roadmap

- [x] Set up Auth (Google OAuth with domain whitelisting)
- [x] Create API project structure (Next.js)
- [x] Build user authentication schema with Prisma
- [x] Generate API endpoints for user management  
- [x] Create Docker Compose setup for development
- [ ] Build product and reservation schema
- [ ] Generate CRUD API endpoints for tours
- [ ] Create staff hub dashboard UI
- [ ] Design website theme and deploy first clone

## 🔐 Authentication Setup

### Google OAuth Configuration

1. **Google Cloud Console Setup:**
   - Create a new project at [Google Cloud Console](https://console.cloud.google.com)
   - Enable Google+ API
   - Create OAuth 2.0 credentials
   - Add authorized redirect URIs: `http://localhost:4000/api/auth/callback/google`

2. **Environment Variables:**
   ```bash
   cp api/.env.example api/.env.local
   # Edit api/.env.local with your Google OAuth credentials
   ```

3. **Domain Whitelisting:**
   - Domains are configured in `API_DOMAIN_WHITELIST` environment variable
   - Additional domains can be added via database (`whitelisted_domains` table)
   - Users from non-whitelisted domains cannot register/login

### API Routes Structure

**Authentication Routes:**
- `POST /api/auth/signin` - Google OAuth login
- `POST /api/auth/signout` - Logout
- `GET /api/auth/session` - Get current session

**Internal Routes (Staff Hub/Protected):**
- `GET /api/internal/users/me` - Get current user profile
- `PUT /api/internal/users/me` - Update user profile

**External Routes (Public):**
- `GET /api/external/health` - Health check endpoint

## 📚 API Documentation

The API includes interactive Swagger documentation:

- **Interactive Docs**: http://localhost:4000/docs - Full Swagger UI with "Try it out" functionality
- **OpenAPI Spec**: http://localhost:4000/api/docs - Raw OpenAPI JSON specification
- **Homepage**: http://localhost:4000 - API overview and quick links

### Features:
- ✅ **Auto-generated** from TypeScript route handlers
- ✅ **Interactive testing** with authentication
- ✅ **Type-safe schemas** with validation examples
- ✅ **Domain whitelisting** documentation
- ✅ **Role-based access** examples
