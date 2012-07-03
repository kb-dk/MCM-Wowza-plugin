#!/bin/bash

if [ $# -ne 2 ]
then
  echo "Usage: `basename $0` WOWZA_SYSTEM_DIR VHOST_DIR"
  echo "  WOWZA_SYSTEM_DIR Top directory of a Wowza, e.g. /usr/local/WowzaMediaServer"
  echo "  VHOST_DIR        VHost directory to deploy application in"
  exit 1
fi

export WOWZA_SYSTEM_DIR="$1"
export VHOST_DIR="$2"

pushd $(dirname $0)/..

mkdir -p $VHOST_DIR/applications/chaos
cp -r conf/chaos $VHOST_DIR/conf/
cp lib/* $WOWZA_SYSTEM_DIR/lib

popd
