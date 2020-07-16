echo "$DEVHUBKEY" > config/devhub-server.key
sed -i "s/||n||/\n/gi" config/devhub-server.key
npm install sfdx-cli --global
bash scripts/dx/authorizeDevhub.sh