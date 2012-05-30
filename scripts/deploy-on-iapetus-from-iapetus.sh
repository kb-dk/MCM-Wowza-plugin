#!/bin/bash

# Expect the deploy package to be in the ~/temp/wowza-plugin folder of the unpacked digitv-package.
# The script is supposed to run on the server where Wowza resides as the larm-user.

PACKAGE_NAME=LARM-CHAOS-Wowza-package.zip
SERVER_DEPLOY_PACKAGE_LIB=~/temp/chaos-wowza-plugin
SERVER_DEPLOY_SETUP_LIB=chaos-deploy-setup
VHOST_HOME=/home/wowza/services/wowza_vhost_chaos_doms

echo Deploying Wowza plugin on server

cd $SERVER_DEPLOY_PACKAGE_LIB

echo - Removing previous deploy-setup folder...
rm -r $SERVER_DEPLOY_SETUP_LIB

echo - Creating new deploy-setup folder...
mkdir $SERVER_DEPLOY_SETUP_LIB

echo - Extracting install package...
unzip -q $PACKAGE_NAME -d $SERVER_DEPLOY_SETUP_LIB

echo - Copy jar-files to ~/wowza/lib/...
cp -r $SERVER_DEPLOY_SETUP_LIB/WowzaSystemDir/lib/* ~/wowza/lib/

echo - Copy VHost files to $VHOST_HOME
rm -r $VHOST_HOME
cp -r $SERVER_DEPLOY_SETUP_LIB/chaosSBVHost $VHOST_HOME
cp ${VHOST_HOME}/conf/VHost_TEST_IAPETUS.xml ${VHOST_HOME}/conf/VHost.xml
cp ${VHOST_HOME}/conf/chaos/Application_DEFAULT.xml ${VHOST_HOME}/conf/chaos/Application.xml
cp ${VHOST_HOME}/conf/chaos/chaos-streaming-server-plugin_TEST_IAPETUS.properties ${VHOST_HOME}/conf/chaos/chaos-streaming-server-plugin.properties
rm -r ${VHOST_HOME}/content
ln -s ~larm/streamingContent ${VHOST_HOME}/content

# Wowza restart script cannot be called remote
#echo - Restarting server...
#echo ====== Server log : Start ======
#~/bin/wowza restart
#echo ====== Server log : End ======

echo - Restart server locally on the machine using the command: "bin/wowza restart"

echo Finished deploying Wowza plugin on server
