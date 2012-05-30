#!/bin/bash

# Expect the deploy package to be in the <Wowza-plugin-dev-dir>/target folder
# The script is supposed to run from the local developer machine in the target folder

PACKAGE_NAME=LARM-CHAOS-Wowza-package.zip
WOWZA_SYSTEM_LIB=/Library/WowzaMediaServer
VHOST_LIB=/Users/henningbottger/services/wowza_vhost_chaos
LOCAL_MACHINE=HEB
TARGET_ENV=SB
#TARGET_ENV=FSKN

echo Deploying Wowza plugin to developer machine
echo - Configuration:
echo - + Package name  : ${PACKAGE_NAME}
echo - + Wowza System  : ${WOWZA_SYSTEM_LIB}
echo - + VHost lib     : ${VHOST_LIB}
echo - + Target env    : ${TARGET_ENV}
echo - + Local machine : ${LOCAL_MACHINE}

echo - Removing previous deploy-setup folder...
rm -rf tmp

echo - Creating new deploy-setup folder...
mkdir tmp

echo - Extracting install package...
unzip -q ${PACKAGE_NAME} -d tmp

echo - Create environment specific configuration files...
VHOST_FOLDER=chaos${TARGET_ENV}VHost
cp tmp/${VHOST_FOLDER}/conf/chaos/chaos-streaming-server-plugin_DEVELOPMENT_${LOCAL_MACHINE}.properties tmp/${VHOST_FOLDER}/conf/chaos/chaos-streaming-server-plugin.properties
cp tmp/${VHOST_FOLDER}/conf/chaos/Application_DEFAULT.xml tmp/${VHOST_FOLDER}/conf/chaos/Application.xml
cp tmp/WowzaSystemDir/conf/VHosts_DEVELOPMENT_${LOCAL_MACHINE}.xml tmp/WowzaSystemDir/conf/VHosts.xml

echo - Update Wowza install dir: ${WOWZA_SYSTEM_LIB}...
cp -r tmp/WowzaSystemDir/* ${WOWZA_SYSTEM_LIB}

echo - Update VHost: ${VHOST_LIB}...
cp -r tmp/${VHOST_FOLDER}/* ${VHOST_LIB}

echo Finished deploying Wowza plugin from developer machine

