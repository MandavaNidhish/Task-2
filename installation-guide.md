# n8n WhatsApp Google Drive Assistant

A complete automation workflow that integrates WhatsApp messaging with Google Drive operations using n8n, enabling users to manage Google Drive files through simple WhatsApp commands.

## 🎯 Project Overview

This project provides a comprehensive n8n workflow that:

- **Listens to WhatsApp messages** via Twilio Sandbox or WhatsApp Cloud API
- **Performs Google Drive operations** (list, delete, move, summarize files)
- **Uses AI summarization** with OpenAI GPT-4o for document analysis
- **Includes audit logging** and safety features
- **Provides Docker deployment** for easy setup and scalability

## ✨ Features

### 📱 WhatsApp Commands
- `LIST /ProjectX` - List files in a folder
- `DELETE /ProjectX/report.pdf` - Delete a specific file
- `MOVE /ProjectX/report.pdf /Archive` - Move file to another folder
- `SUMMARY /ProjectX` - Generate AI summaries of documents

### 🔐 Security & Safety
- OAuth2 authentication for Google Drive
- Audit logging for all operations
- Safety guards against accidental mass deletion
- Encrypted credentials storage

### 🤖 AI Integration
- OpenAI GPT-4o for document summarization
- Support for PDF, DOCX, and TXT files
- Intelligent content analysis and bullet-point summaries

## 📋 System Requirements

### Hardware Requirements
- **CPU**: Dual-core processor (2+ cores recommended)
- **RAM**: 4GB minimum (8GB recommended for production)
- **Storage**: 20GB free space
- **Network**: Stable internet connection

### Software Requirements
- **Docker**: Version 20.10.0 or later
- **Docker Compose**: Version 2.0 or later (or Docker with Compose plugin)
- **Operating System**: 
  - Linux (Ubuntu 20.04+, CentOS 8+, Debian 11+)
  - macOS 10.15+
  - Windows 10/11 with WSL2

## 🛠 Prerequisites Installation

### Docker Installation

#### Linux (Ubuntu/Debian)
```bash
# Update package index
sudo apt update && sudo apt upgrade -y

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Add user to docker group
sudo usermod -aG docker $USER

# Start Docker service
sudo systemctl enable --now docker

# Verify installation
docker --version
docker compose version
```

#### macOS
```bash
# Using Homebrew
brew install --cask docker

# Or download Docker Desktop from:
# https://www.docker.com/products/docker-desktop
```

#### Windows
1. Enable WSL2 feature
2. Download and install Docker Desktop from [docker.com](https://www.docker.com/products/docker-desktop)
3. Ensure WSL2 backend is enabled in Docker Desktop settings

### API Accounts Setup

#### 1. Twilio WhatsApp Sandbox
1. Sign up at [twilio.com](https://www.twilio.com)
2. Navigate to Console → Develop → Messaging → Try it out → Send a WhatsApp message
3. Follow instructions to join the sandbox
4. Note down:
   - Account SID
   - Auth Token
   - WhatsApp sandbox number: `+14155238886`

#### 2. Google Drive OAuth2
1. Go to [Google Cloud Console](https://console.cloud.google.com)
2. Create a new project or select existing one
3. Enable Google Drive API:
   - Navigate to APIs & Services → Library
   - Search for "Google Drive API" and enable it
4. Create credentials:
   - Go to APIs & Services → Credentials
   - Click "Create Credentials" → OAuth 2.0 Client IDs
   - Set Application Type: Web Application
   - Add authorized redirect URIs: `http://localhost:5678/rest/oauth2-credential/callback`
5. Download the JSON credentials file
6. Note down Client ID and Client Secret

#### 3. OpenAI API
1. Sign up at [openai.com](https://openai.com)
2. Navigate to API section
3. Create new API key
4. Copy the API key (starts with `sk-`)

#### 4. WhatsApp Business Cloud API (Optional)
1. Create Meta Developer account at [developers.facebook.com](https://developers.facebook.com)
2. Create Business Portfolio at [business.facebook.com](https://business.facebook.com)
3. Create new app with WhatsApp product
4. Note down App ID and App Secret

## 🚀 Quick Start Installation

### Option 1: Automated Setup (Recommended)

```bash
# Clone or download the project files
# Make sure you have all required files in one directory

# Run the automated setup script
./setup.sh
```

The script will:
- Check Docker installation
- Verify required files
- Guide you through environment setup
- Start all services
- Provide next steps

### Option 2: Manual Installation

#### Step 1: Download Project Files
Ensure you have these files in your project directory:
- `docker-compose.yml`
- `whatsapp-gdrive-workflow.json`
- `.env.example`
- `setup.sh`

#### Step 2: Configure Environment
```bash
# Copy environment template
cp .env.example .env

# Edit the .env file with your API credentials
nano .env
```

Update these values in `.env`:
```bash
N8N_ENCRYPTION_KEY=your-super-secret-key-min-32-chars
TWILIO_ACCOUNT_SID=your_twilio_account_sid
TWILIO_AUTH_TOKEN=your_twilio_auth_token
GOOGLE_CLIENT_ID=your_google_client_id
GOOGLE_CLIENT_SECRET=your_google_client_secret
OPENAI_API_KEY=sk-your_openai_api_key
```

#### Step 3: Start Services
```bash
# Create necessary directories
mkdir -p ./n8n_data ./logs

# Start all services
docker compose up -d

# Check service status
docker compose ps
```

#### Step 4: Access n8n
1. Open browser and go to `http://localhost:5678`
2. Create admin account (first time only)
3. Import workflow from `whatsapp-gdrive-workflow.json`

## ⚙️ Configuration

### 1. Import Workflow
1. Access n8n at `http://localhost:5678`
2. Click the workflow menu (three dots) → "Import from File"
3. Select `whatsapp-gdrive-workflow.json`
4. Click "Import"

### 2. Configure Credentials
Set up these credentials in n8n:

#### Twilio API
- Name: `twilio-api`
- Account SID: From Twilio Console
- Auth Token: From Twilio Console

#### Google Drive OAuth2
- Name: `google-drive-oauth`
- Client ID: From Google Cloud Console
- Client Secret: From Google Cloud Console
- Scope: `https://www.googleapis.com/auth/drive`

#### OpenAI API
- Name: `openai-api`
- API Key: From OpenAI platform

### 3. Configure Webhook
1. In n8n, note the webhook URL (usually `http://your-domain:5678/webhook/whatsapp-gdrive-webhook`)
2. In Twilio Console:
   - Go to WhatsApp Sandbox Settings
   - Set "When a message comes in" webhook URL to your n8n webhook
   - Set HTTP method to POST

### 4. Test Integration
Send a WhatsApp message to the Twilio sandbox number:
```
join [your-sandbox-code]
```
Then try:
```
LIST /
```

## 📁 Project Structure

```
n8n-whatsapp-gdrive/
├── docker-compose.yml          # Docker services configuration
├── whatsapp-gdrive-workflow.json # n8n workflow definition
├── .env.example               # Environment template
├── .env                       # Your actual environment (do not commit)
├── setup.sh                   # Automated setup script
├── installation-guide.md      # This documentation
├── n8n_data/                  # n8n persistent data
├── logs/                      # Application logs
└── README.md                  # Project overview
```

## 🔧 Management Commands

### Service Management
```bash
# Start services
docker compose up -d

# Stop services
docker compose down

# Restart services
docker compose restart

# View logs
docker compose logs -f n8n

# Update to latest n8n version
docker compose pull
docker compose up -d
```

### Backup & Restore
```bash
# Backup n8n data
docker run --rm -v n8n-whatsapp-gdrive_n8n_data:/data -v $(pwd):/backup alpine tar czf /backup/n8n_backup_$(date +%Y%m%d_%H%M%S).tar.gz -C /data .

# Restore n8n data
docker run --rm -v n8n-whatsapp-gdrive_n8n_data:/data -v $(pwd):/backup alpine tar xzf /backup/n8n_backup_YYYYMMDD_HHMMSS.tar.gz -C /data
```

## 📱 Usage Examples

### Basic Commands
- `LIST /ProjectX` - Show all files in ProjectX folder
- `DELETE /ProjectX/oldfile.pdf` - Delete a specific file
- `MOVE /ProjectX/report.pdf /Archive` - Move file to Archive folder
- `SUMMARY /ProjectX` - Get AI summary of all documents in folder

### Advanced Usage
- Use folder paths like `/Work/2024/Reports`
- File operations support various formats (PDF, DOCX, TXT, etc.)
- Summaries work best with text-based documents

## 🛡 Security Best Practices

### Environment Security
```bash
# Set proper file permissions
chmod 600 .env
chmod 755 setup.sh

# Use strong encryption key (32+ characters)
openssl rand -base64 32
```

### Production Deployment
1. Use HTTPS with SSL certificates
2. Enable authentication in n8n
3. Use external database (PostgreSQL)
4. Set up proper firewall rules
5. Regular backups
6. Monitor logs for suspicious activity

### API Security
- Rotate API keys regularly
- Use minimum required permissions
- Monitor API usage
- Enable 2FA on all accounts

## 🔍 Troubleshooting

### Common Issues

#### "Docker not found"
```bash
# Check Docker installation
docker --version
docker compose version

# Restart Docker service (Linux)
sudo systemctl restart docker
```

#### "Port 5678 already in use"
```bash
# Check what's using the port
sudo lsof -i :5678

# Change port in docker-compose.yml
ports:
  - "8080:5678"  # Use port 8080 instead
```

#### "n8n won't start"
```bash
# Check logs
docker compose logs n8n

# Check available memory
free -h

# Restart services
docker compose restart
```

#### "Webhook not receiving messages"
1. Verify webhook URL is accessible from internet
2. Use ngrok for local testing:
   ```bash
   ngrok http 5678
   ```
3. Update Twilio webhook URL with ngrok URL
4. Check n8n webhook logs

#### "Google Drive authentication fails"
1. Verify OAuth2 credentials
2. Check redirect URI matches exactly
3. Ensure Google Drive API is enabled
4. Test with Google OAuth Playground

### Log Analysis
```bash
# View all logs
docker compose logs

# Follow specific service logs
docker compose logs -f n8n
docker compose logs -f postgres
docker compose logs -f redis

# View workflow execution logs in n8n UI
# Go to Executions tab in n8n interface
```

### Performance Optimization
```bash
# Increase Docker memory limit (if needed)
# Edit Docker Desktop settings or systemd service

# Monitor resource usage
docker stats

# Optimize workflow execution
# Use "Queue Mode" for heavy workloads
# Enable Redis for better performance
```

## 📈 Production Considerations

### Scaling
- Use external PostgreSQL database
- Enable Redis for queue management
- Consider n8n cluster setup for high availability
- Use load balancer for multiple instances

### Monitoring
- Set up health checks
- Monitor API rate limits
- Track workflow execution times
- Set up alerting for failures

### Backup Strategy
- Daily automated backups of n8n data
- Weekly full system backups
- Test restore procedures regularly
- Store backups in multiple locations

## 🤝 Contributing

1. Fork the repository
2. Create feature branch
3. Add tests for new functionality
4. Submit pull request with detailed description

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🆘 Support

### Getting Help
- Check the troubleshooting section above
- Review n8n documentation: [docs.n8n.io](https://docs.n8n.io)
- Twilio WhatsApp documentation: [twilio.com/docs/whatsapp](https://www.twilio.com/docs/whatsapp)
- Google Drive API documentation: [developers.google.com/drive](https://developers.google.com/drive)

### Community Resources
- n8n Community: [community.n8n.io](https://community.n8n.io)
- GitHub Discussions
- Discord Server (link in n8n documentation)

## 📚 Additional Resources

### Learning Materials
- [n8n Workflow Automation Course](https://docs.n8n.io/courses/)
- [Docker Compose Tutorial](https://docs.docker.com/compose/gettingstarted/)
- [WhatsApp Business API Guide](https://developers.facebook.com/docs/whatsapp)

### API Documentation
- [n8n API Reference](https://docs.n8n.io/api/)
- [Twilio WhatsApp API](https://www.twilio.com/docs/whatsapp/api)
- [Google Drive API](https://developers.google.com/drive/api/v3/reference)
- [OpenAI API](https://platform.openai.com/docs/api-reference)

---

🚀 **Happy Automating!** This guide should get you up and running with your WhatsApp Google Drive Assistant. Remember to keep your API keys secure and enjoy the power of automation!