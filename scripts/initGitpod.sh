npm install sfdx-cli --global
sfdx force:auth:jwt:grant --clientid $DEVHUBCONSUMERKEY --jwtkeyfile config/devhub-server.key --username $DEVHUBUSERNAME --setdefaultdevhubusername -a DEVHUB