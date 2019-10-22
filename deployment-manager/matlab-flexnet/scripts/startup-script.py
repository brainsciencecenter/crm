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

def main( ):

    #TO DO: Provide instructions for setting up the matlab license server

    print( 'Hello World' )

if __name__ == '__main__':
    main()

