#!/bin/bash

sfdx force:auth:jwt:grant --clientid $DEVHUBCONSUMERKEY --jwtkeyfile config/devhub-server.key --username $DEVHUBUSERNAME --setdefaultdevhubusername -a DEVHUB