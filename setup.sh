#!/bin/bash

# n8n WhatsApp Google Drive Assistant - Setup Script
# This script automates the installation and setup process

set -e  # Exit on any error

echo "🚀 Starting n8n WhatsApp Google Drive Assistant Setup..."
echo "=================================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_header() {
    echo -e "${BLUE}=== $1 ===${NC}"
}

# Check if Docker is installed
check_docker() {
    print_header "Checking Docker Installation"
    if ! command -v docker &> /dev/null; then
        print_error "Docker is not installed. Please install Docker first."
        echo "Visit: https://docs.docker.com/get-docker/"
        exit 1
    fi
    print_status "Docker is installed: $(docker --version)"

    if ! command -v docker-compose &> /dev/null; then
        print_warning "docker-compose not found. Trying docker compose..."
        if ! docker compose version &> /dev/null; then
            print_error "Neither docker-compose nor docker compose found."
            exit 1
        fi
        DOCKER_COMPOSE_CMD="docker compose"
    else
        DOCKER_COMPOSE_CMD="docker-compose"
    fi
    print_status "Using: $DOCKER_COMPOSE_CMD"
}

# Check if required files exist
check_files() {
    print_header "Checking Required Files"
    required_files=("docker-compose.yml" ".env" "whatsapp-gdrive-workflow.json")

    for file in "${required_files[@]}"; do
        if [[ ! -f "$file" ]]; then
            print_error "Required file $file not found!"
            exit 1
        fi
        print_status "Found: $file"
    done
}

# Create necessary directories
create_directories() {
    print_header "Creating Directories"
    mkdir -p ./n8n_data
    mkdir -p ./logs
    print_status "Directories created successfully"
}

# Set up environment variables
setup_env() {
    print_header "Environment Setup"
    if [[ ! -f ".env" ]]; then
        print_warning ".env file not found. Creating from .env.example..."
        cp .env.example .env
    fi

    print_warning "Please update the .env file with your actual API credentials:"
    echo "  - Twilio Account SID and Auth Token"
    echo "  - Google Drive OAuth2 credentials"  
    echo "  - OpenAI API Key"
    echo "  - WhatsApp Business API credentials"
    echo ""
    read -p "Have you updated the .env file with your credentials? (y/n): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_error "Please update the .env file before continuing."
        exit 1
    fi
}

# Start n8n services
start_services() {
    print_header "Starting n8n Services"
    print_status "Building and starting containers..."

    $DOCKER_COMPOSE_CMD up -d

    if [[ $? -eq 0 ]]; then
        print_status "Services started successfully!"
        print_status "Waiting for n8n to be ready..."
        sleep 30

        # Check if n8n is responding
        if curl -s http://localhost:5678/healthz > /dev/null; then
            print_status "n8n is ready!"
        else
            print_warning "n8n may still be starting up. Please wait a few more seconds."
        fi
    else
        print_error "Failed to start services."
        exit 1
    fi
}

# Import workflow
import_workflow() {
    print_header "Importing Workflow"
    print_status "n8n is now running at: http://localhost:5678"
    print_status "Please manually import the workflow:"
    echo "  1. Open http://localhost:5678 in your browser"
    echo "  2. Click on 'Import from File' in the workflow menu (three dots)"
    echo "  3. Select the 'whatsapp-gdrive-workflow.json' file"
    echo "  4. Configure the credentials for:"
    echo "     - Twilio API"
    echo "     - Google Drive OAuth2"
    echo "     - OpenAI API"
}

# Show final instructions
show_instructions() {
    print_header "Setup Complete!"
    echo "🎉 Your n8n WhatsApp Google Drive Assistant is ready!"
    echo ""
    echo "📋 Next Steps:"
    echo "  1. Access n8n at: http://localhost:5678"
    echo "  2. Import the workflow from: whatsapp-gdrive-workflow.json"
    echo "  3. Configure API credentials in n8n"
    echo "  4. Set up Twilio WhatsApp Sandbox webhook to your n8n URL"
    echo "  5. Test the integration with WhatsApp commands"
    echo ""
    echo "📖 Commands to try:"
    echo "  LIST /ProjectX"
    echo "  DELETE /ProjectX/report.pdf"
    echo "  MOVE /ProjectX/report.pdf /Archive"
    echo "  SUMMARY /ProjectX"
    echo ""
    echo "🔧 Management Commands:"
    echo "  Stop services: $DOCKER_COMPOSE_CMD down"
    echo "  View logs: $DOCKER_COMPOSE_CMD logs -f n8n"
    echo "  Restart: $DOCKER_COMPOSE_CMD restart"
    echo ""
    print_status "Setup completed successfully! 🚀"
}

# Main execution
main() {
    check_docker
    check_files
    create_directories
    setup_env
    start_services
    import_workflow
    show_instructions
}

# Run main function
main
