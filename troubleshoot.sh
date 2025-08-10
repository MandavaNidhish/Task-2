#!/bin/bash

# n8n WhatsApp Google Drive Assistant - Troubleshooting Script
# This script runs diagnostic checks for common issues

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🔍 n8n WhatsApp Google Drive Assistant - Diagnostic Tool${NC}"
echo "========================================================="

# Check Docker installation
echo -e "${YELLOW}🐳 Checking Docker installation...${NC}"
if command -v docker &> /dev/null; then
    echo -e "${GREEN}✅ Docker installed: $(docker --version)${NC}"

    if docker compose version &> /dev/null; then
        echo -e "${GREEN}✅ Docker Compose available${NC}"
    else
        echo -e "${RED}❌ Docker Compose not found${NC}"
    fi
else
    echo -e "${RED}❌ Docker not installed${NC}"
    exit 1
fi

# Check container status
echo -e "${YELLOW}📦 Checking container status...${NC}"
if docker compose ps --format table; then
    echo -e "${GREEN}✅ Containers are running${NC}"
else
    echo -e "${RED}❌ No containers running${NC}"
fi

# Check ports
echo -e "${YELLOW}🔌 Checking port availability...${NC}"
if netstat -tuln | grep :5678 &> /dev/null; then
    echo -e "${GREEN}✅ Port 5678 is in use (n8n should be running)${NC}"
else
    echo -e "${RED}❌ Port 5678 is not in use${NC}"
fi

# Check n8n health
echo -e "${YELLOW}🏥 Checking n8n health...${NC}"
if curl -s -f http://localhost:5678/healthz &> /dev/null; then
    echo -e "${GREEN}✅ n8n is healthy${NC}"
else
    echo -e "${RED}❌ n8n health check failed${NC}"
fi

# Check disk space
echo -e "${YELLOW}💾 Checking disk space...${NC}"
df -h | grep -E "Filesystem|/$"

# Check Docker volumes
echo -e "${YELLOW}📁 Checking Docker volumes...${NC}"
docker volume ls | grep n8n

# Check logs for errors
echo -e "${YELLOW}📋 Checking recent logs for errors...${NC}"
echo "Last 10 log entries:"
docker compose logs --tail=10 n8n 2>/dev/null || echo "No logs available"

echo ""
echo -e "${BLUE}🛠️ Common Solutions:${NC}"
echo "1. Restart services: docker compose restart"
echo "2. View full logs: docker compose logs -f n8n"
echo "3. Check environment: cat .env"
echo "4. Reset containers: docker compose down && docker compose up -d"
echo "5. Check webhook URL in Twilio console"
echo "6. Verify API credentials in n8n interface"

echo ""
echo -e "${GREEN}✨ Diagnostic complete!${NC}"
