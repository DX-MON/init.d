#!/bin/bash
########################################################################
# Begin $rc_base/init.d/reboot
#
# Description : Reboot Scripts
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
		boot_mesg "Restarting system..."
		reboot -d -f -i
		;;

	*)
		echo "Usage: ${0} {stop}"
		exit 1
		;;

esac

# End $rc_base/init.d/reboot
