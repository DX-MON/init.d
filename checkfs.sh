#!/bin/bash
########################################################################
# Begin $rc_base/init.d/checkfs
#
# Description : File System Check
#
# Authors     : Gerard Beekmans - gerard@linuxfromscratch.org
#		A. Luebke - luebke@users.sourceforge.net
#
# Version     : 00.00
#
# Notes       :
#
# Based on checkfs script from LFS-3.1 and earlier.
#
# From man fsck
# 0    - No errors
# 1    - File system errors corrected
# 2    - System should be rebooted
# 4    - File system errors left uncorrected
# 8    - Operational error
# 16   - Usage or syntax error
# 32   - Fsck canceled by user request
# 128  - Shared library error
#
#########################################################################

. /etc/sysconfig/rc
. ${rc_functions}

case "${1}" in
	start)
		if [ -f /fastboot ]; then
			boot_mesg -n "/fastboot found, will not perform" ${INFO}
			boot_mesg " file system checks as requested."
			echo_ok
			exit 0
		fi

		boot_mesg -n "Mounting root file system in read-only mode..." ${INFO}
		boot_mesg "" ${NORMAL}
		mount -n -o remount,ro / >/dev/null
		evaluate_retval

		if [ ${?} != 0 ]; then
			echo_failure
			boot_mesg -n "FAILURE:\n\nCannot check root" ${FAILURE}
			boot_mesg -n " filesystem because it could not be mounted"
			boot_mesg -n " in read-only mode.\n\nAfter you"
			boot_mesg -n " press Enter, this system will be"
			boot_mesg -n " halted and powered off."
			boot_mesg -n "\n\nPress enter to continue..." ${INFO}
			boot_mesg "" ${NORMAL}
			read ENTER
			${rc_base}/init.d/halt stop
		fi

		if [ -f /forcefsck ]; then
			boot_mesg -n "/forcefsck found, forcing file" ${INFO}
			boot_mesg " system checks as requested."
			echo_ok
			options="-f"
		else
			options=""
		fi

		boot_mesg -n "Checking file systems..." ${INFO}
		boot_mesg "" ${NORMAL}
		# Note: -a option used to be -p; but this fails e.g.
		# on fsck.minix
		fsck ${options} -a -A -C -T
		error_value=${?}

		if [ "${error_value}" = 0 ]; then
			echo_ok
		fi

		if [ "${error_value}" = 1 ]; then
			echo_warning
			boot_mesg -n "WARNING:\n\nFile system errors" ${WARNING}
			boot_mesg -n " were found and have been corrected."
			boot_mesg -n "  You may want to double-check that"
			boot_mesg -n " everything was fixed properly."
			boot_mesg "" ${NORMAL}
		fi

		if [ "${error_value}" = 2 -o "${error_value}" = 3 ]; then
			echo_warning
			boot_mesg -n "WARNING:\n\nFile system errors" ${WARNING}
			boot_mesg -n " were found and have been been"
 			boot_mesg -n " corrected, but the nature of the"
			boot_mesg -n " errors require this system to be"
			boot_mesg -n " rebooted.\n\nAfter you press enter,"
			boot_mesg -n " this system will be rebooted"
			boot_mesg -n "\n\nPress Enter to continue..." ${INFO}
			boot_mesg "" ${NORMAL}
			read ENTER
			reboot -f
		fi

		if [ "${error_value}" -gt 3 -a "${error_value}" -lt 16 ]; then
			echo_failure
			boot_mesg -n "FAILURE:\n\nFile system errors" ${FAILURE}
			boot_mesg -n " were encountered that could not be"
			boot_mesg -n " fixed automatically.  This system"
			boot_mesg -n " cannot continue to boot and will"
			boot_mesg -n " therefore be halted until those"
			boot_mesg -n " errors are fixed manually by a"
			boot_mesg -n " System Administrator.\n\nAfter you"
			boot_mesg -n " press Enter, this system will be"
			boot_mesg -n " halted and powered off."
			boot_mesg -n "\n\nPress Enter to continue..." ${INFO}
			boot_mesg "" ${NORMAL}
			read ENTER
			${rc_base}/init.d/halt stop
		fi

		if [ "${error_value}" -ge 16 ]; then
			echo_failure
			boot_mesg -n "FAILURE:\n\nUnexpected Failure" ${FAILURE}
			boot_mesg -n " running fsck.  Exited with error"
			boot_mesg -n " code: ${error_value}."
			boot_mesg "" ${NORMAL}
			exit ${error_value}
		fi
		;;
	*)
		echo "Usage: ${0} {start}"
		exit 1
		;;
esac

# End $rc_base/init.d/checkfs
