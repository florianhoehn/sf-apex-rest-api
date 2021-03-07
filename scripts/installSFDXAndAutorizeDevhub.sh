#!/bin/bash

echo "$DEVHUBKEY" > config/devhub-server.key
sed -i "s/||n||/\n/gi" config/devhub-server.key
yarn && yarn global add sfdx-cli
bash scripts/dx/authorizeDevhub.sh