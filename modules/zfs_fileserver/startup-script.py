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

def update_centos_kernel( ):

    subprocess.call( shlex.split('yum -y install kernel') )
    subprocess.call( shlex.split('yum -y update') )
    subprocess.call( shlex.split('touch /opt/kernel-updated') )
    subprocess.call( shlex.split('shutdown -r now') )

#END update_centos_kernel

def setup_selinux():

    subprocess.call(shlex.split('setenforce 0'))
    f = open('/etc/selinux/config', 'w')
    f.write("""
SELINUX=permissive
SELINUXTYPE=targeted
""")
    f.close()
#END setup_selinux()

def install_zfs( ):

    packages = [ 'kernel-devel',
                 'kernel-headers',
                 'epel-release',
                 'dkms']

    while subprocess.call(['yum', 'install', '-y'] + packages):
        print "yum failed to install packages. Trying again in 5 seconds"
        time.sleep(5)

    subprocess.call( shlex.split('yum install -y http://download.zfsonlinux.org/epel/zfs-release.el7_7.noarch.rpm') )
    subprocess.call( shlex.split('yum install -y zfs') )


    # Touch a file to indicate zfs has been installed 
    # This prevents running through this again if the instances is rebooted.
    subprocess.call( shlex.split('touch /opt/zfs-installed') )

#END install_zfs
def setup_zfs( ):

    # Create a mount point for the storage disk and make it writeable by all
    subprocess.call( shlex.split('mkdir -p /mnt/zfs') )
    subprocess.call( shlex.split('chmod a+w /mnt/disks/zfs') )

    # Initialize ZFS with modprobe and set up mount from /dev/sdb
    subprocess.call( shlex.split('/sbin/modprobe zfs') )
    subprocess.call( shlex.split('zpool create -m /mnt/zfs data-pool /dev/sdb') )

#END setup_zfs

def main( ):

    if not os.path.exists('/opt/kernel-updated'):
        setup_selinux( )
        update_centos_kernel( )

    if not os.path.exists('/opt/zfs-installed'):
        install_zfs( )
        setup_zfs( )


if __name__ == '__main__':
    main()

