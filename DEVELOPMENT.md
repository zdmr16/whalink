# 🛠️ Whalink Development Guide

Complete guide for setting up and developing Whalink locally.

## 📋 Prerequisites

- Docker & Docker Compose (20.10+)
- Git
- Node.js 20+ (for local development without Docker)
- 4GB RAM minimum
- 20GB disk space

## 🏗️ Project Structure

```
whalink/
├── backend/              # Evolution API (Git submodule)
│   ├── src/              # TypeScript source code
│   ├── prisma/           # Database schemas & migrations
│   ├── Dockerfile        # Production build
│   └── Dockerfile.dev    # Development with hot reload
│
├── frontend/             # Evolution Manager (Git submodule)
│   ├── src/              # React/TypeScript source
│   ├── Dockerfile        # Production build (Vite + Nginx)
│   └── Dockerfile.dev    # Development with HMR
│
├── docker/               # Docker configurations
│   ├── nginx/            # Nginx configs
│   └── monitoring/       # Prometheus & Grafana configs
│
├── scripts/              # Utility scripts
│   ├── generate-ssl.sh   # SSL certificate generator
│   └── seed-database.sh  # Database seeder
│
├── data/                 # Persistent data (gitignored)
│   ├── postgres/
│   ├── redis/
│   ├── evolution/
│   ├── prometheus/
│   └── grafana/
│
├── docker-compose.yml        # Production setup
├── docker-compose.dev.yml    # Development setup (hot reload)
├── .env                      # Production environment
├── .env.development          # Development environment
└── .env.example              # Environment template
```

## 🚀 Quick Start

### 1. Clone Repository with Submodules

```bash
# Clone the repository
git clone --recurse-submodules https://github.com/yourusername/whalink.git
cd whalink

# If you already cloned without submodules:
git submodule update --init --recursive
```

### 2. Environment Setup

```bash
# Copy development environment
cp .env.development .env

# OR create custom .env
cp .env.example .env
nano .env  # Edit with your values
```

### 3. Start Development Environment

```bash
# Start all services with hot reload
make dev

# OR using docker-compose directly
docker-compose -f docker-compose.dev.yml up
```

### 4. Access Services

| Service | URL | Description |
|---------|-----|-------------|
| Frontend | http://localhost:5173 | Evolution Manager (Vite HMR) |
| Backend API | http://localhost:8080 | Evolution API |
| Swagger Docs | http://localhost:8080/manager | API Documentation |
| Grafana | http://localhost:3001 | Monitoring Dashboard |
| Prometheus | http://localhost:9091 | Metrics |
| PostgreSQL | localhost:5432 | Database |
| Redis | localhost:6379 | Cache |

---

## 🔥 Development Workflow

### Hot Reload

**Backend (Evolution API):**
- Uses `tsx watch` for TypeScript hot reload
- Changes in `backend/src/**/*.ts` trigger automatic restart
- No need to rebuild Docker image

**Frontend (Evolution Manager):**
- Uses Vite HMR (Hot Module Replacement)
- Changes in `frontend/src/**/*` update instantly in browser
- Ultra-fast development experience

### Making Code Changes

#### Backend Changes

```bash
# 1. Edit TypeScript files
nano backend/src/api/routes/example.ts

# 2. Changes auto-reload (tsx watch)
# Check logs:
docker-compose -f docker-compose.dev.yml logs -f evolution-api

# 3. If you add new dependencies:
docker-compose -f docker-compose.dev.yml down
docker-compose -f docker-compose.dev.yml build evolution-api
docker-compose -f docker-compose.dev.yml up -d
```

#### Frontend Changes

```bash
# 1. Edit React components
nano frontend/src/components/Example.tsx

# 2. Browser updates automatically (Vite HMR)
# Check logs:
docker-compose -f docker-compose.dev.yml logs -f evolution-manager
```

### Database Changes

#### Create Migration

```bash
# Enter backend container
docker-compose -f docker-compose.dev.yml exec evolution-api sh

# Create migration
npm run db:migrate:dev

# Exit container
exit
```

#### Apply Migration

```bash
# Migrations are auto-applied on container start
# OR manually:
docker-compose -f docker-compose.dev.yml exec evolution-api npm run db:deploy
```

#### Seed Database

```bash
# From host
./scripts/seed-database.sh

# OR from container
docker-compose -f docker-compose.dev.yml exec evolution-api npm run db:seed
```

---

## 📦 Working with Git Submodules

### Update Submodules (Pull Latest Changes)

```bash
# Update all submodules to latest
git submodule update --remote --merge

# Update specific submodule
git submodule update --remote backend
git submodule update --remote frontend
```

### Commit Submodule Changes

```bash
# 1. Make changes in submodule
cd backend
nano src/some-file.ts

# 2. Commit in submodule
git add .
git commit -m "feat: add new feature"

# 3. Go back to main repo
cd ..

# 4. Commit submodule pointer update
git add backend
git commit -m "chore: update backend submodule"
```

### Check Submodule Status

```bash
# Show submodule status
git submodule status

# Show submodule summary
git submodule summary
```

---

## 🧪 Testing

### Run Backend Tests

```bash
# Enter container
docker-compose -f docker-compose.dev.yml exec evolution-api sh

# Run tests
npm test

# Exit
exit
```

### Run Frontend Tests

```bash
# Enter container
docker-compose -f docker-compose.dev.yml exec evolution-manager sh

# Run tests
npm test

# Exit
exit
```

---

## 🐛 Debugging

### View Logs

```bash
# All services
make logs

# Specific service
make logs service=evolution-api
make logs service=evolution-manager
make logs service=postgres

# OR with docker-compose
docker-compose -f docker-compose.dev.yml logs -f evolution-api
```

### Enter Container Shell

```bash
# Backend
make shell-api
# OR
docker-compose -f docker-compose.dev.yml exec evolution-api sh

# Frontend
docker-compose -f docker-compose.dev.yml exec evolution-manager sh

# Database
make shell-db
# OR
docker-compose -f docker-compose.dev.yml exec postgres psql -U evolution
```

### Check Health

```bash
# Backend health
curl http://localhost:8080/health

# PostgreSQL
docker-compose -f docker-compose.dev.yml exec postgres pg_isready -U evolution

# Redis
docker-compose -f docker-compose.dev.yml exec redis redis-cli ping
```

---

## 📝 Code Quality

### Linting

```bash
# Backend (ESLint)
cd backend
npm run lint        # Auto-fix
npm run lint:check  # Check only

# Frontend (ESLint)
cd frontend
npm run lint        # Auto-fix
npm run lint:check  # Check only
```

### Formatting

```bash
# Frontend (Prettier)
cd frontend
npm run format        # Format all
npm run format:check  # Check only
```

### Type Checking

```bash
# Backend
cd backend
npm run build  # TypeScript compilation

# Frontend
cd frontend
npm run type-check
```

---

## 🔧 Common Issues & Solutions

### Port Already in Use

```bash
# Check what's using the port
sudo lsof -i :8080
sudo lsof -i :5173

# Kill the process
kill -9 <PID>

# OR change port in docker-compose.dev.yml
```

### Submodule Not Initialized

```bash
# Initialize all submodules
git submodule update --init --recursive
```

### Docker Build Cache Issues

```bash
# Rebuild without cache
docker-compose -f docker-compose.dev.yml build --no-cache

# Remove all containers and rebuild
make clean
make dev
```

### Database Connection Failed

```bash
# Check if Postgres is running
docker-compose -f docker-compose.dev.yml ps

# Check logs
docker-compose -f docker-compose.dev.yml logs postgres

# Restart database
docker-compose -f docker-compose.dev.yml restart postgres
```

### Hot Reload Not Working

**Backend:**
```bash
# Check if volume is mounted
docker inspect whalink_evolution_api_dev | grep Mounts -A 20

# Restart with fresh build
docker-compose -f docker-compose.dev.yml up --build
```

**Frontend:**
```bash
# Check Vite HMR connection in browser console
# Should see: [vite] connected.

# If not working, restart:
docker-compose -f docker-compose.dev.yml restart evolution-manager
```

---

## 🚀 Production Build

### Build All Services

```bash
# Using docker-compose
docker-compose build

# OR using Make
make build
```

### Test Production Build Locally

```bash
# Start production containers
docker-compose up -d

# Check status
make status
```

---

## 📚 Additional Resources

### Evolution API Documentation
- Official Docs: https://doc.evolution-api.com
- GitHub: https://github.com/EvolutionAPI/evolution-api
- Swagger: http://localhost:8080/manager

### Evolution Manager Documentation
- GitHub: https://github.com/EvolutionAPI/evolution-manager-v2

### Tech Stack Documentation
- TypeScript: https://www.typescriptlang.org/docs/
- Prisma: https://www.prisma.io/docs/
- Express: https://expressjs.com/
- React: https://react.dev/
- Vite: https://vite.dev/
- Docker: https://docs.docker.com/

---

## 🤝 Contributing

1. Create a feature branch
2. Make your changes with hot reload
3. Test thoroughly
4. Commit with conventional commits
5. Push and create PR

```bash
git checkout -b feature/my-feature
# Make changes...
git add .
git commit -m "feat: add awesome feature"
git push origin feature/my-feature
```

---

## 💡 Tips & Best Practices

1. **Always use development compose** for local work
2. **Commit submodule changes separately** from main repo
3. **Keep .env.development** with simple passwords
4. **Use hot reload** - don't rebuild unless dependencies change
5. **Check logs frequently** when debugging
6. **Run tests** before committing
7. **Update submodules regularly** to stay current

---

Happy coding! 🎉
