#!/bin/bash
# Begin $rc_base/init.d/apache

# Based on sysklogd script from LFS-3.1 and earlier.
# Rewritten by Gerard Beekmans  - gerard@linuxfromscratch.org

#$LastChangedBy: bdubbs $
#$Date: 2005-08-01 14:29:19 -0500 (Mon, 01 Aug 2005) $

. /etc/sysconfig/rc
. $rc_functions

case "$1" in
	start)
		boot_mesg "Starting Apache daemon..." ${SUCCESS}
		/usr/sbin/apachectl -k start
		evaluate_retval
		;;

	stop)
		boot_mesg "Stopping Apache daemon..." ${FAILURE}
		/usr/sbin/apachectl -k stop
		evaluate_retval
		;;

	restart)
		boot_mesg "Restarting Apache daemon..." ${WARNING}
		/usr/sbin/apachectl -k restart
		evaluate_retval
		;;

	status)
		statusproc /usr/sbin/httpd
		;;

	*)
		echo "Usage: $0 {start|stop|restart|status}"
		exit 1
		;;
esac

# End $rc_base/init.d/apache
