#!/usr/bin/python
#
# Author : Joseph Schoonover, Fluid Numerics LLC ( joe@fluidnumerics.com )
#
# Written for BSC Pilot Project ( Sept. - Oct. 2019 ) [Sponsored by Google LLC]
#
# This script is used as a startup script on CentOS 7 to install zfs server
# The following assumptions are made
#   > The compute instance has 1 boot disk (primary) and 1 storage disk (secondary)
#   > The secondary disk is mounted to /mnt/zfs

import subprocess
import shlex
import os
from parse import compile

def update_centos_kernel( ):

    subprocess.call( shlex.split('yum -y install kernel') )
    subprocess.call( shlex.split('yum -y update') )
    subprocess.call( shlex.split('touch /opt/kernel-updated') )
    subprocess.call( shlex.split('shutdown -r now') )

#END update_centos_kernel

def setup_secondary_disk( ):

    # Reformat the secondary disk to ext4
    subprocess.call( shlex.split('mkfs.ext4 -m 0 -F -E lazy_itable_init=0,lazy_journal_init=0,discard /dev/sdb') )

    # Create a mount point for the storage disk and make it writeable by all
    subprocess.call( shlex.split('mkdir -p /mnt/zfs') )
    subprocess.call( shlex.split('chmod a+w /mnt/disks/zfs') )

    # Add the fstab entry for this
    subprocess.call( shlex.split('echo UUID=`sudo blkid -s UUID -o value /dev/sdb` /mnt/zfs ext4 discard,defaults,nofail 0 2 | sudo tee -a /etc/fstab') )

    # Mount the disk
    subprocess.call( shlex.split('mount -a') )


#END setup_secondary_disk

def install_zfs( ):

    packages = [ 'kernel-devel',
                 'kernel-headers',
                 'epel-release',
                 'dkms',
                 'zfs' ]

    while subprocess.call(['yum', 'install', '-y'] + packages):
        print "yum failed to install packages. Trying again in 5 seconds"
        time.sleep(5)

#END install_zfs

def main( ):

    if not os.path.exists('/opt/kernel-updated'):
        update_centos_kernel( )

    setup_secondary_disk( )

    install_zfs( )

