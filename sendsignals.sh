#!/bin/bash
########################################################################
# Begin $rc_base/init.d/sendsignals
#
# Description : Sendsignals Script
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
		boot_mesg "Sending all processes the TERM signal..."
		killall5 -15
		error_value=${?}

		sleep ${KILLDELAY}

		if [ "${error_value}" = 0 ]; then
			echo_ok
		else
			echo_failure
		fi

		boot_mesg "Sending all processes the KILL signal..."
		killall5 -9
		error_value=${?}

		sleep ${KILLDELAY}

		if [ "${error_value}" = 0 ]; then
			echo_ok
		else
			echo_failure
		fi
		;;

	*)
		echo "Usage: ${0} {stop}"
		exit 1
		;;

esac

# End $rc_base/init.d/sendsignals
