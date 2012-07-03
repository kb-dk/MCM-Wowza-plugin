#!/bin/bash

if [ $# -ne 4 ]
then
  echo "Usage: `basename $0` WOWZA_SYSTEM_DIR VHOST_DIR VHOST_NAME PORT_INCREASE"
  echo "  WOWZA_SYSTEM_DIR Top directory of a Wowza, e.g. /usr/local/WowzaMediaServer"
  echo "  VHOST_DIR        Directory to deploy new VHost in"
  echo "  VHOST_NAME       The name of the VHost"
  echo "  PORT_INCREASE    Increase of port numbers relative to VHost.xml in Wowza"
  exit 1
fi

export WOWZA_SYSTEM_DIR="$1"
export VHOST_DIR="$2"
export VHOST_NAME="$3"
export PORT_INCREASE="$4"

# Create VHost directory
mkdir -p $VHOST_DIR/applications
mkdir -p $VHOST_DIR/content
mkdir -p $VHOST_DIR/conf
mkdir -p $VHOST_DIR/keys
mkdir -p $VHOST_DIR/logs


# Copy files to VHost directory
cp -u \
   $WOWZA_SYSTEM_DIR/conf/Application.xml \
   $WOWZA_SYSTEM_DIR/conf/Authentication.xml \
   $WOWZA_SYSTEM_DIR/conf/HTTPStreamers.xml \
   $WOWZA_SYSTEM_DIR/conf/LiveStreamPacketizers.xml \
   $WOWZA_SYSTEM_DIR/conf/MediaCasters.xml \
   $WOWZA_SYSTEM_DIR/conf/MediaReaders.xml \
   $WOWZA_SYSTEM_DIR/conf/MediaWriters.xml \
   $WOWZA_SYSTEM_DIR/conf/MP3Tags.xml \
   $WOWZA_SYSTEM_DIR/conf/RTP.xml \
   $WOWZA_SYSTEM_DIR/conf/StartupStreams.xml \
   $WOWZA_SYSTEM_DIR/conf/Streams.xml \
   $WOWZA_SYSTEM_DIR/conf/VHost.xml \
   $WOWZA_SYSTEM_DIR/conf/admin.password \
   $WOWZA_SYSTEM_DIR/conf/publish.password \
       $VHOST_DIR/conf

# Remove old VHost entry (if any)
perl -0777 -pe 's%\s*<VHost>\s*<Name>'"$VHOST_NAME"'</Name>\s*<ConfigDir>[^<]*</ConfigDir>\s*<ConnectionLimit>[^/]*</ConnectionLimit>\s*</VHost>*%%g' -i $WOWZA_SYSTEM_DIR/conf/VHosts.xml

# Add new VHost entry
perl -0777 -pe 's%<VHosts>%<VHosts>
        <VHost>
            <Name>'"$VHOST_NAME"'</Name>
            <ConfigDir>'"$VHOST_DIR"'</ConfigDir>
            <ConnectionLimit>0</ConnectionLimit>
        </VHost>%g' -i $WOWZA_SYSTEM_DIR/conf/VHosts.xml

# Increase port number if VHost was copied
diff --brief $WOWZA_SYSTEM_DIR/conf/VHost.xml $VHOST_DIR/conf/VHost.xml && perl -0777 -pe 's%<Port>(\d*)</Port>%"<Port>" . ($1 + '"$PORT_INCREASE"') . "</Port>"%ge' -i $VHOST_DIR/conf/VHost.xml
