#!/bin/bash

# Docker-specific build script for Gooner Linux
# This script runs inside the Docker container without permission issues

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m'

print_status() {
    echo -e "${BLUE}[DOCKER-BUILD]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_status "Starting Gooner Linux build in Docker container..."
print_status "Running as user: $(whoami)"
print_status "Current directory: $(pwd)"

# Ensure we have proper permissions for the workspace
if [[ ! -w /workspace ]]; then
    print_error "No write permissions to /workspace"
    exit 1
fi

# Run the main build script with necessary modifications for Docker
export DOCKER_BUILD=1
export WORK_DIR="/workspace/gooner-build"
export ISO_OUTPUT="/workspace/output"

# Create output directory with proper permissions
mkdir -p "$ISO_OUTPUT"

# Modify the build script to work in Docker environment
print_status "Executing build script..."

# Call the main build script
./build_gooner.sh

print_success "Build completed! ISO should be in $ISO_OUTPUT/"