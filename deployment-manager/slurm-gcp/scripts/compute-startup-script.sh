#!/bin/bash

export MOUNT_DIR=@MOUNT_DIR@
export GID=@GID@
export NFS_DATA_SERVER=@NFS_DATA_SERVER@
export NFS_DATA_DIR=@NFS_DATA_DIR@

echo "10.10.0.9	matlab-server.gcp.pennbrain.upenn.edu matlab-server" >> /etc/hosts

mkdir /mnt/${MOUNT_DIR}
mount -t nfs ${NFS_DATA_SERVER}:${NFS_DATA_DIR} ${MOUNT_DIR}
chown -R root:${GID} ${MOUNT_DIR}
chmod -R g=rwx ${MOUNT_DIR}

