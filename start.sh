#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'
Text="${GREEN}[STARTUP]${NC}"

echo -e "${Text} ${BLUE}Starting checks for all updates...${NC}"

RELEASE_PAGE=$(curl -sSL https://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/)
CHANGELOGS_PAGE=$(curl -sSL https://changelogs-live.fivem.net/api/changelog/versions/linux/server)

if [[ "${AUTO_UPDATE}" == "1" ]]; then
    DOWNLOAD_LINK=$(echo $CHANGELOGS_PAGE | jq -r '.latest_download')
    rm -rf /home/container/alpine > /dev/null 2>&1
    echo -e "${Text} ${BLUE}Updating CitizenFX Resource Files...${NC}"
    curl -sSL ${DOWNLOAD_LINK} -o ${DOWNLOAD_LINK##*/} > /dev/null 2>&1
    tar -xvf ${DOWNLOAD_LINK##*/} > /dev/null 2>&1
    rm -rf ${DOWNLOAD_LINK##*/} run.sh > /dev/null 2>&1
    echo -e "${Text} ${BLUE}CitizenFX Resources updated successfully!${NC}"
else 
    echo -e "${Text} ${BLUE}Auto Update is disabled!${NC}"
fi

echo -e "${Text} ${BLUE}Preparing environment variables...${NC}"

export TXHOST_DATA_PATH=/home/container/txData
export TXHOST_MAX_SLOTS=${MAX_PLAYERS}
export TXHOST_TXA_PORT=${TXADMIN_PORT}
export TXHOST_FXS_PORT=${SERVER_PORT}
export TXHOST_DEFAULT_CFXKEY=${FIVEM_LICENSE}
export TXHOST_PROVIDER_NAME=${PROVIDER_NAME}
export TXHOST_PROVIDER_LOGO=${PROVIDER_LOGO}

SERVER_BIN_PATH="/home/container/alpine/opt/cfx-server/FXServer"
if [ ! -f "$SERVER_BIN_PATH" ]; then
    echo -e "${RED}[ERROR] FiveM server binary not found at ${SERVER_BIN_PATH}${NC}"
    exit 1
fi

METRIC_URL="http://api.luxxysystems.com/api/metrics"
SERVER_ID="${P_SERVER_UUID:-unknown}"

(
    while true; do
        TIMESTAMP=$(date +%s)
        IS_RUNNING=1

        curl -s -X POST "$METRIC_URL" \
            -H "Content-Type: application/json" \
            -d "{
                \"server_id\": \"${SERVER_ID}\",
                \"is_running\": ${IS_RUNNING},
                \"timestamp\": ${TIMESTAMP}
            }" > /dev/null || echo "[WARN] Failed to report status for ${SERVER_ID}"

        sleep 10
    done
) &

echo -e "${Text} ${BLUE}Running the FiveM server with txAdmin...${NC}"
$(pwd)/alpine/opt/cfx-server/ld-musl-x86_64.so.1 \
  --library-path "$(pwd)/alpine/usr/lib/v8/:$(pwd)/alpine/lib/:$(pwd)/alpine/usr/lib/:$(pwd)/alpine/opt/cfx-server/lib/" \
  -- $(pwd)/alpine/opt/cfx-server/FXServer \
  +set citizen_dir $(pwd)/alpine/opt/cfx-server/citizen/ \
  $( [ "$TXADMIN_ENABLE" == "1" ] || printf %s '+exec server.cfg' )
