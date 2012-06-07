#!/bin/bash

# Expect the deploy package to be in the <Wowza-plugin-dev-dir> folder
# The script is supposed to run from the local developer machine in the target folder

PACKAGE_NAME=LARM-CHAOS-Wowza-package.zip
SERVER_DEPLOY_SCRIPT=deploy-on-local-machine-kfc.sh


echo Installing wowza plugin on local machine:
echo - Building package...
ant clean package
cd target
echo - Extracting deploy script from package...
unzip -q $PACKAGE_NAME WowzaSystemDir/bin/$SERVER_DEPLOY_SCRIPT
echo - Moving deploy script from subdirectory...
mv WowzaSystemDir/bin/$SERVER_DEPLOY_SCRIPT .
echo - Setting executable flag...
chmod +x $SERVER_DEPLOY_SCRIPT
echo - Cleanup...
rm -r WowzaSystemDir
echo - Start deploy script...
echo '---===<<< start >>>===---'
./$SERVER_DEPLOY_SCRIPT
echo '---===<<<  end  >>>===---'
echo Done
