#!/bin/bash
cd /home/container || exit 1

# Configure colors
CYAN='\033[0;36m'
RESET_COLOR='\033[0m'

# Replace Startup Variables
# shellcheck disable=SC2086
echo -e "${CYAN}STARTUP /home/container: /start.sh ${RESET_COLOR}"
# Run the Server
# shellcheck disable=SC2086

clear

eval './start.sh'