#!/bin/bash
cd /home/container || exit 1

# Configure colors
CYAN='\033[0;36m'
RESET_COLOR='\033[0m'

# Set environment variable that holds the Internal Docker IP
INTERNAL_IP=$(ip route get 1 | awk '{print $(NF-2);exit}')
export INTERNAL_IP
# Replace Startup Variables
# shellcheck disable=SC2086
echo -e "${CYAN}STARTUP /home/container: /start.sh ${RESET_COLOR}"
# Run the Server
# shellcheck disable=SC2086

clear

eval '/start.sh'