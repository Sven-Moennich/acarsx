#!/bin/bash
### BEGIN INIT INFO
#
# Provides:		acarsx
# Required-Start:	$all
# Required-Stop:	
# Default-Start:	2 3 4 5
# Default-Stop:		0 1 6
# Short-Description:	acarsx initscript

#
### END INIT INFO
## Fill in name of program here.
PROG_PATH="/usr/local/bin"
PROG="$PROG_PATH/acarsx"

ACARS_LOG=acars-$(date -u +"%y%m").log

PROG_ARGS="-d -l /var/log/${ACARS_LOG} -r 0 131.450"
PIDFILE="/var/run/acarsx.pid"

start() {
      if [ -e $PIDFILE ]; then
          ## Program is running, exit with error.
          echo "Error! $PROG is currently running!" 1>&2
      else
          ## Change from /dev/null to something like /var/log/$PROG if you want to save output.
          #$PROG $PROG_ARGS 2>&1 >/dev/null
          start-stop-daemon --start --quiet --oknodo --pidfile $PIDFILE --exec $PROG -- $PROG_ARGS
          echo "$PROG started"
          touch $PIDFILE
      fi
}

stop() {
      if [ -e $PIDFILE ]; then
         echo "$PROG is running"
         #killall $PROG
         start-stop-daemon --stop --quiet --oknodo --exec $PROG
         rm -f $PIDFILE
         echo "$PROG stopped"
      else
          ## Program is not running, exit with error.
          echo "Error! $PROG not started!" 1>&2
      fi
}

## Check to see if we are running as root first.
## Found at http://www.cyberciti.biz/tips/shell-root-user-check-script.html
if [ "$(id -u)" != "0" ]; then
      echo "This script must be run as root" 1>&2
      exit 1
fi

case "$1" in
      start)
          start
          exit 0
      ;;
      stop)
          stop
          exit 0
      ;;
      reload|restart|force-reload)
          stop
          start
          exit 0
      ;;
      **)
          echo "Usage: $0 {start|stop|reload}" 1>&2
          exit 1
      ;;
esac
#
