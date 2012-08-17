#!/bin/bash

PACKAGE_NAME="LARM-CHAOS-Wowza-*"
WOWZA_SYSTEM_LIB=/usr/local/WowzaMediaServer
VHOST_LIB=/home/kfc/build/larm/services/wowza_vhost_chaos
ENVIRONMENT=DEVELOPMENT_KFC
PORT_INCREMENT=1

echo Installing wowza plugin on local machine:
echo - Building package...
mvn clean package
cd target
echo - Extracting package...
unzip -q $PACKAGE_NAME-bundle.zip
cd $PACKAGE_NAME
echo - Setup VHost...
bin/setup-external-vhost.sh $WOWZA_SYSTEM_LIB $VHOST_LIB _chaosVHost_ $PORT_INCREMENT
echo - Start deploy script...
bin/deploy.sh $WOWZA_SYSTEM_LIB $VHOST_LIB
echo - Installing custom configuration
if [ -e conf/examples/chaos/chaos-streaming-server-plugin_$ENVIRONMENT.properties ]; then cp conf/examples/chaos/chaos-streaming-server-plugin_$ENVIRONMENT.properties $VHOST_LIB/conf/chaos/chaos-streaming-server-plugin.properties; fi
if [ -e conf/examples/chaos/Application_$ENVIRONMENT.xml ]; then cp conf/examples/chaos/Application_$ENVIRONMENT.xml $VHOST_LIB/conf/chaos/Application.xml; fi
echo Done
