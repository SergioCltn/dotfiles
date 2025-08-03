#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

# Function to print messages
print_message() {
    echo -e "${GREEN}[INFO] $1${NC}"
}

# Function to print errors
print_error() {
    echo -e "${RED}[ERROR] $1${NC}" >&2
}
