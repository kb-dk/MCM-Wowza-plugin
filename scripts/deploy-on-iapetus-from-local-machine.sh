#!/bin/bash

# Expect the deploy package to be in the <Wowza-plugin-dev-dir>/target folder
# The script is supposed to run from the local developer machine in the target folder

PACKAGE_NAME=LARM-CHAOS-Wowza-package.zip
SERVER_DEPLOY_SCRIPT=deploy-on-iapetus-from-iapetus.sh
SERVER_DEPLOY_PACKAGE_LIB=/home/wowza/temp/chaos-wowza-plugin

echo Deploying Wowza plugin from developer machine

echo - Copying wowza plugin package to server...
scp $PACKAGE_NAME wowza@iapetus:$SERVER_DEPLOY_PACKAGE_LIB

echo - Extracting server deploy script from package...
unzip -q $PACKAGE_NAME WowzaSystemDir/bin/$SERVER_DEPLOY_SCRIPT

echo - Copying deploy script to server...
scp WowzaSystemDir/bin/$SERVER_DEPLOY_SCRIPT wowza@iapetus:$SERVER_DEPLOY_PACKAGE_LIB

echo === Executing deploy script on server ===
ssh -t wowza@iapetus source $SERVER_DEPLOY_PACKAGE_LIB/$SERVER_DEPLOY_SCRIPT
echo === Finished deploy script on server ===

echo Finished deploying Wowza plugin from developer machine

