#!/bin/bash
## Make Colorful text for the console
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo -e "${GREEN}Starting Pterodactyl fivem this may take a while..${NC}"
RELEASE_PAGE=$(curl -sSL https://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/)
CHANGELOGS_PAGE=$(curl -sSL https://changelogs-live.fivem.net/api/changelog/versions/linux/server)
echo -e "${GREEN}Starting FiveM Server...${NC}"

if [[ "${AUTO_UPDATE}" == "1" ]]; then
    DOWNLOAD_LINK=$(echo $CHANGELOGS_PAGE | jq -r '.latest_download')

    rm -rf /home/container/alpine

    echo -e "Downloading latest version of FiveM..."

    curl -sSL ${DOWNLOAD_LINK} -o ${DOWNLOAD_LINK##*/}
    echo "Extracting fivem files"
    tar -xvf ${DOWNLOAD_LINK##*/}
    rm -rf ${DOWNLOAD_LINK##*/} run.sh
else 
    echo -e "Using local version of FiveM... not downloading latest."
fi



echo -e "${GREEN}Starting FiveM Binary...${NC} Have Fun!"
echo -e "${GREEN}This Egg was made by Luxxy-GF${NC}"
echo -e "${RED} Github: Luxxy-GF | Discord: LuxxyWasTaken${NC}"
$(pwd)/alpine/opt/cfx-server/ld-musl-x86_64.so.1 --library-path "$(pwd)/alpine/usr/lib/v8/:$(pwd)/alpine/lib/:$(pwd)/alpine/usr/lib/" -- $(pwd)/alpine/opt/cfx-server/FXServer +set citizen_dir $(pwd)/alpine/opt/cfx-server/citizen/ +set sv_licenseKey ${FIVEM_LICENSE} +set steam_webApiKey ${STEAM_WEBAPIKEY} +set sv_maxplayers ${MAX_PLAYERS} +set serverProfile ${TXADMIN_PROFILE} +set txAdminPort ${TXADMIN_PORT}  $( [ "$TXADMIN_ENABLE" == "1" ] || printf %s '+exec server.cfg' )
## FIVEM_LICENSE, STEAM_WEBAPIKEY, MAX_PLAYERS, TXADMIN_PROFILE, TXADMIN_PORT, TXADMIN_ENABLE