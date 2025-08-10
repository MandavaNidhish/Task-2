#!/bin/bash

# n8n WhatsApp Google Drive Assistant - Backup Script
# This script creates automated backups of your n8n data

set -e

# Configuration
BACKUP_DIR="./backups"
CONTAINER_PREFIX="n8n-whatsapp-gdrive"
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_NAME="n8n_backup_${DATE}"

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}🔄 Starting n8n Backup Process...${NC}"
echo "=============================================="

# Create backup directory
mkdir -p "$BACKUP_DIR"

# Create backup archive
echo -e "${YELLOW}📦 Creating backup archive...${NC}"
docker run --rm \
  -v ${CONTAINER_PREFIX}_n8n_data:/data:ro \
  -v $(pwd)/$BACKUP_DIR:/backup \
  alpine \
  tar czf /backup/$BACKUP_NAME.tar.gz -C /data .

if [ $? -eq 0 ]; then
  echo -e "${GREEN}✅ Backup created successfully!${NC}"
  echo "📁 Location: $BACKUP_DIR/$BACKUP_NAME.tar.gz"
  echo "📊 Size: $(du -h $BACKUP_DIR/$BACKUP_NAME.tar.gz | cut -f1)"
else
  echo -e "${RED}❌ Backup failed!${NC}"
  exit 1
fi

# Cleanup old backups (keep last 7 days)
echo -e "${YELLOW}🧹 Cleaning up old backups...${NC}"
find $BACKUP_DIR -name "n8n_backup_*.tar.gz" -type f -mtime +7 -delete

echo -e "${GREEN}🎉 Backup process completed!${NC}"
echo ""
echo "💡 To restore this backup, run:"
echo "   ./restore.sh $BACKUP_NAME.tar.gz"
