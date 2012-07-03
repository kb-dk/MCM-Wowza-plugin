#!/bin/bash

PACKAGE_NAME="LARM-CHAOS-Wowza-*"
WOWZA_SYSTEM_LIB=/home/wowza/wowza
VHOST_LIB=/home/wowza/services/wowza_vhost_chaos_doms
ENVIRONMENT=TEST_IAPETUS
PORT_INCREMENT=3

echo Installing wowza plugin on iapetus:
echo - Building package...
mvn clean package
echo - Removing old install packages on iapetus
ssh wowza@iapetus "cd temp;rm -rf $PACKAGE_NAME-*"
echo - Copying package to iapetus
scp target/$PACKAGE_NAME-bundle.zip wowza@iapetus:temp/
echo - Extracting package...
ssh wowza@iapetus "cd temp;rm -rf $PACKAGE_NAME-bundle;unzip -q $PACKAGE_NAME-bundle.zip"
echo - Setup VHost...
ssh wowza@iapetus "cd temp/$PACKAGE_NAME;bin/setup-external-vhost.sh $WOWZA_SYSTEM_LIB $VHOST_LIB _chaosDomsVHost_ $PORT_INCREMENT"
echo - Start deploy script...
ssh wowza@iapetus "cd temp/$PACKAGE_NAME;bin/deploy.sh $WOWZA_SYSTEM_LIB $VHOST_LIB"
echo - Installing custom configuration
if [ -e conf/examples/chaos/chaos-streaming-server-plugin_$ENVIRONMENT.properties ]; then scp conf/examples/chaos/chaos-streaming-server-plugin_$ENVIRONMENT.properties wowza@iapetus:$VHOST_LIB/conf/chaos/chaos-streaming-server-plugin.properties; fi
if [ -e conf/examples/chaos/Application_$ENVIRONMENT.xml ]; then scp conf/examples/chaos/Application_$ENVIRONMENT.xml wowza@iapetus:$VHOST_LIB/conf/chaos/conf/examples/chaos/Application.xml; fi
echo Done

