#!/bin/bash
########################################################################
# Begin $rc_base/init.d/halt
#
# Description : Halt Script
#
# Authors     : Gerard Beekmans - gerard@linuxfromscratch.org
#
# Version     : 00.00
#
# Notes       :
#
########################################################################

. /etc/sysconfig/rc
. ${rc_functions}

case "${1}" in
	stop)
		halt -d -f -i -p
		;;
	*)
		echo "Usage: {stop}"
		exit 1
		;;
esac

# End $rc_base/init.d/halt
