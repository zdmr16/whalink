# 🚀 Whalink - WhatsApp API Management Platform

A fully dockerized WhatsApp API management platform powered by [Evolution API](https://github.com/EvolutionAPI/evolution-api), featuring real-time messaging, monitoring, and a beautiful web interface.

**⚡ Built from Source** - Includes Evolution API and Evolution Manager as Git submodules for full source code access and customization.

## 🎯 Quick Links

- **[Development Guide](DEVELOPMENT.md)** - Complete guide for local development with hot reload
- **[Evolution API Docs](https://doc.evolution-api.com)** - Official API documentation
- **[Changelog](CHANGELOG.md)** - Version history and updates

## ✨ Features

### Core Features
- ✅ **WhatsApp Integration** - Full WhatsApp Web API support via Baileys library
- ✅ **Multi-Instance Management** - Manage multiple WhatsApp connections
- ✅ **Real-time WebSocket** - Live message notifications and updates
- ✅ **Web Dashboard** - Modern UI for managing instances and messages
- ✅ **RESTful API** - Complete API for automation and integrations
- ✅ **SSL/HTTPS** - Secure communication with self-signed certificates
- ✅ **Monitoring** - Prometheus metrics + Grafana dashboards

### Technical Stack
- **Evolution API** - WhatsApp integration engine
- **PostgreSQL** - Reliable data persistence
- **Redis** - High-performance caching
- **Nginx** - SSL/HTTPS reverse proxy
- **Prometheus** - Metrics collection
- **Grafana** - Monitoring dashboards

### Evolution API Capabilities
- Send/receive text, media, and document messages
- Group management (create, update, participants)
- Contact management and synchronization
- Message history and persistence
- Typing indicators and presence
- Profile management
- QR code generation for authentication
- Webhook support for event notifications
- Audio/video message support
- Location sharing
- Button and list messages
- Message reactions
- View once messages

## 📋 Prerequisites

- Docker (20.10+)
- Docker Compose (2.0+)
- 2GB RAM minimum
- 10GB disk space

## 🔧 Installation

### Production Setup

### 1. Clone the Repository with Submodules
```bash
# Clone with submodules (includes Evolution API and Manager source code)
git clone --recurse-submodules https://github.com/yourusername/whalink.git
cd whalink

# If you already cloned without submodules:
git submodule update --init --recursive
```

### 2. Configure Environment
```bash
# Copy example environment file
cp .env.example .env

# Edit with your preferences
nano .env
```

**Important:** Update these values in `.env`:
- `POSTGRES_PASSWORD` - Database password
- `API_KEY` - Evolution API authentication key (generate random 32 chars)
- `GRAFANA_PASSWORD` - Grafana admin password

### 3. Generate SSL Certificates
```bash
# Generate self-signed certificates for localhost
./scripts/generate-ssl.sh
```

### 4. Start Services
```bash
# Using docker-compose
docker-compose up -d

# OR using Makefile
make start
```

## 🌐 Access URLs

After starting the services:

| Service | URL | Credentials |
|---------|-----|-------------|
| **Manager UI** | https://localhost | - |
| **Evolution API** | https://localhost/api | API Key in .env |
| **Grafana** | https://localhost/grafana | admin / (see .env) |
| **Prometheus** | http://localhost:9091 | - |

**Note:** Browser will show SSL warning for self-signed certificate. Click "Advanced" and proceed.

---

## 🔥 Development Setup

Want to modify the source code or contribute? We've got you covered with hot reload!

### Quick Start Development

```bash
# 1. Clone with submodules (if not done already)
git clone --recurse-submodules https://github.com/yourusername/whalink.git
cd whalink

# 2. Copy development environment
cp .env.development .env

# 3. Start development environment (hot reload enabled!)
make dev

# 4. Access development URLs
# Frontend (Vite HMR):  http://localhost:5173
# Backend API:          http://localhost:8080
# Swagger Docs:         http://localhost:8080/manager
```

### Development Features

✅ **Hot Reload** - Changes in backend/frontend auto-reload
✅ **Source Code Access** - Full Evolution API & Manager source code
✅ **Debugging** - Direct access to logs and containers
✅ **Fast Iteration** - No rebuild needed for code changes

**See [DEVELOPMENT.md](DEVELOPMENT.md) for complete development guide including:**
- Hot reload workflow
- Database migrations
- Git submodule management
- Testing & debugging
- Code quality tools

---

## 📖 Quick Start Guide

### 1. Create WhatsApp Instance

**Using Web UI:**
1. Open https://localhost
2. Navigate to "Instances"
3. Click "Create Instance"
4. Scan QR code with WhatsApp mobile app
5. Start messaging!

**Using API:**
```bash
curl -X POST https://localhost/api/instance/create \
  -H "apikey: YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "instanceName": "my-whatsapp",
    "qrcode": true
  }'
```

### 2. Send a Message
```bash
curl -X POST https://localhost/api/message/sendText/my-whatsapp \
  -H "apikey: YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "number": "5511999999999",
    "textMessage": {
      "text": "Hello from Whalink!"
    }
  }'
```

### 3. Monitor Your System
- Open Grafana: https://localhost/grafana
- Default credentials: `admin` / `your_grafana_password`
- View Evolution API metrics dashboard

## 🛠️ Makefile Commands

```bash
make help        # Show all available commands
make install     # First-time installation
make start       # Start all services
make stop        # Stop all services
make restart     # Restart services
make logs        # View logs (all services)
make logs service=evolution-api  # View specific service logs
make status      # Show services status
make backup      # Create backup
make update      # Update Docker images
make clean       # Remove all data (WARNING!)
make ssl         # Regenerate SSL certificates
```

## 📊 Architecture

```
┌─────────────────────────────────────────────────┐
│                   NGINX (SSL)                    │
│            Reverse Proxy + HTTPS                 │
└─────────────────┬───────────────────────────────┘
                  │
        ┌─────────┴─────────┬──────────┬──────────┐
        │                   │          │          │
┌───────▼────────┐  ┌──────▼─────┐ ┌──▼─────┐ ┌──▼─────┐
│ Evolution API  │  │  Manager   │ │Grafana │ │Prometh-│
│   (WhatsApp)   │  │     UI     │ │        │ │  eus   │
└───────┬────────┘  └────────────┘ └────────┘ └────────┘
        │
   ┌────┴─────┐
   │          │
┌──▼─────┐ ┌─▼────┐
│Postgres│ │Redis │
└────────┘ └──────┘
```

## 🔒 Security Notes

### For Development (localhost)
- Self-signed SSL certificates are automatically generated
- Browser warnings are normal - click "Advanced" and proceed

### For Production
Replace self-signed certificates with proper SSL certificates:

1. **Using Let's Encrypt:**
```bash
# Install certbot
apt-get install certbot

# Generate certificate
certbot certonly --standalone -d yourdomain.com

# Copy certificates
cp /etc/letsencrypt/live/yourdomain.com/fullchain.pem ssl/localhost.crt
cp /etc/letsencrypt/live/yourdomain.com/privkey.pem ssl/localhost.key

# Restart nginx
docker-compose restart nginx
```

2. **Update .env:**
```bash
SERVER_URL=https://yourdomain.com
```

3. **Update nginx config:**
Edit `nginx/conf.d/whalink.conf` and change `server_name` from `localhost` to your domain.

## 🔧 Configuration

### Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `POSTGRES_DB` | Database name | evolution |
| `POSTGRES_USER` | Database user | evolution |
| `POSTGRES_PASSWORD` | Database password | (required) |
| `SERVER_URL` | Public server URL | https://localhost |
| `API_KEY` | Evolution API key | (required) |
| `GRAFANA_USER` | Grafana admin user | admin |
| `GRAFANA_PASSWORD` | Grafana password | (required) |

### Evolution API Features

Enable/disable in `docker-compose.yml`:

```yaml
environment:
  - WEBSOCKET_ENABLED=true        # Real-time notifications
  - TYPEBOT_ENABLED=false         # Chatbot integration
  - CHATWOOT_ENABLED=false        # Customer service
  - OPENAI_ENABLED=false          # AI features
  - RABBITMQ_ENABLED=false        # Message queue
  - S3_ENABLED=false              # Cloud storage
```

## 📡 API Documentation

### Base URL
```
https://localhost/api
```

### Authentication
All API requests require the `apikey` header:
```bash
-H "apikey: YOUR_API_KEY"
```

### Common Endpoints

**Instance Management:**
- `POST /instance/create` - Create instance
- `GET /instance/fetchInstances` - List instances
- `DELETE /instance/delete/{instance}` - Delete instance
- `GET /instance/connect/{instance}` - Get QR code

**Messaging:**
- `POST /message/sendText/{instance}` - Send text
- `POST /message/sendMedia/{instance}` - Send media
- `POST /message/sendButtons/{instance}` - Send buttons
- `POST /message/sendList/{instance}` - Send list

**Contacts:**
- `GET /chat/findContacts/{instance}` - Get contacts
- `GET /chat/findMessages/{instance}` - Get messages

For complete API documentation, visit: https://doc.evolution-api.com

## 🐛 Troubleshooting

### Ports Already in Use
```bash
# Check which process is using the port
sudo lsof -i :443
sudo lsof -i :8080

# Kill the process or change ports in docker-compose.yml
```

### Services Not Starting
```bash
# Check logs
make logs

# Check specific service
make logs service=evolution-api

# Restart services
make restart
```

### Database Connection Issues
```bash
# Check PostgreSQL logs
docker-compose logs postgres

# Verify database is healthy
docker-compose ps

# Reset database (WARNING: deletes all data)
docker-compose down -v
docker-compose up -d
```

### SSL Certificate Issues
```bash
# Regenerate certificates
make ssl

# Restart nginx
docker-compose restart nginx
```

### WhatsApp Connection Issues
1. Ensure phone has internet connection
2. Make sure WhatsApp is installed and registered
3. Check QR code hasn't expired (refresh after 60s)
4. Try creating a new instance

## 🔄 Backup & Restore

### Create Backup
```bash
make backup
# Creates: backups/whalink_backup_YYYYMMDD_HHMMSS.tar.gz
```

### Restore Backup
```bash
# Stop services
make stop

# Extract backup
tar -xzf backups/whalink_backup_YYYYMMDD_HHMMSS.tar.gz

# Start services
make start
```

## 📦 Updating

```bash
# Pull latest images
make update

# Restart services with new images
make restart
```

## 📝 Logs

```bash
# All services
make logs

# Specific service
make logs service=evolution-api
make logs service=postgres
make logs service=nginx
make logs service=grafana
```

## 🤝 Contributing

Contributions are welcome! Please:
1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Open a Pull Request

## 📄 License

This project is based on [Evolution API](https://github.com/EvolutionAPI/evolution-api) which is licensed under Apache License 2.0.

**Important:** As per Evolution API license requirements:
- Display Evolution API attribution in your system
- Preserve logos in frontend components
- See Evolution API license for full details

## 🙏 Credits

- [Evolution API](https://github.com/EvolutionAPI/evolution-api) - WhatsApp integration engine
- [Baileys](https://github.com/WhiskeySockets/Baileys) - WhatsApp Web API library

## 📞 Support

- 📖 [Evolution API Documentation](https://doc.evolution-api.com)
- 🐛 [Report Issues](https://github.com/yourusername/whalink/issues)
- 💬 [Discussions](https://github.com/yourusername/whalink/discussions)

---

**Made with ❤️ for the open-source community**
