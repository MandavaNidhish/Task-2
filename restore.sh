#!/bin/bash

# n8n WhatsApp Google Drive Assistant - Restore Script
# This script restores n8n data from backup

set -e

# Check if backup file is provided
if [ -z "$1" ]; then
    echo "❌ Usage: $0 <backup_file.tar.gz>"
    echo "📋 Available backups:"
    ls -la ./backups/n8n_backup_*.tar.gz 2>/dev/null || echo "   No backups found"
    exit 1
fi

BACKUP_FILE="$1"
CONTAINER_PREFIX="n8n-whatsapp-gdrive"

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}🔄 Starting n8n Restore Process...${NC}"
echo "=============================================="

# Check if backup file exists
if [ ! -f "./backups/$BACKUP_FILE" ]; then
    echo -e "${RED}❌ Backup file not found: ./backups/$BACKUP_FILE${NC}"
    exit 1
fi

# Stop n8n services
echo -e "${YELLOW}🛑 Stopping n8n services...${NC}"
docker compose down

# Restore data
echo -e "${YELLOW}📦 Restoring data from backup...${NC}"
docker run --rm \
  -v ${CONTAINER_PREFIX}_n8n_data:/data \
  -v $(pwd)/backups:/backup \
  alpine \
  sh -c "rm -rf /data/* && tar xzf /backup/$BACKUP_FILE -C /data"

if [ $? -eq 0 ]; then
  echo -e "${GREEN}✅ Data restored successfully!${NC}"
else
  echo -e "${RED}❌ Restore failed!${NC}"
  exit 1
fi

# Start services
echo -e "${YELLOW}🚀 Starting n8n services...${NC}"
docker compose up -d

echo -e "${GREEN}🎉 Restore process completed!${NC}"
echo ""
echo "💡 n8n should be available at: http://localhost:5678"
