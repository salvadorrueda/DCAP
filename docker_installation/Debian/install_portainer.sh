#!/bin/bash

# Portainer Installation Script for Debian/Ubuntu
# This script installs Portainer Community Edition (CE) as a Docker container.

# Colors for output
RED='\033[0-31m'
GREEN='\033[0-32m'
NC='\033[0m' # No Color

echo -e "${GREEN}Starting Portainer installation...${NC}"

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo -e "${RED}Error: Docker is not installed. Please install Docker first.${NC}"
    exit 1
fi

# Create a persistent volume for Portainer data
echo -e "${GREEN}Creating Portainer data volume...${NC}"
docker volume create portainer_data

# Pull and run Portainer CE
echo -e "${GREEN}Starting Portainer container...${NC}"
docker run -d \
  -p 8000:8000 \
  -p 9443:9443 \
  --name portainer \
  --restart=always \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v portainer_data:/data \
  portainer/portainer-ce:latest

# Check if container is running
if [ "$(docker inspect -f '{{.State.Running}}' portainer)" == "true" ]; then
    echo -e "${GREEN}Portainer has been successfully installed and started!${NC}"
    echo -e "You can access it at: https://localhost:9443"
    echo -e "Note: Replace 'localhost' with your server's IP address if accessing remotely."
else
    echo -e "${RED}Failed to start Portainer container. Please check docker logs.${NC}"
fi
