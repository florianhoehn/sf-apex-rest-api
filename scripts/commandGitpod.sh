echo "$DEVHUBKEY" > config/devhub-server.key
sed -i "s/||n||/\n/gi" config/devhub-server.key
npm install sfdx-cli --global
sfdx force:auth:jwt:grant --clientid $DEVHUBCONSUMERKEY --jwtkeyfile config/devhub-server.key --username $DEVHUBUSERNAME --setdefaultdevhubusername -a DEVHUB