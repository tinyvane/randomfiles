#!/bin/sh
# /etc/init.d/btsync

### BEGIN INIT INFO
# Provides: btsybc daemon
# Required-Start: $remote_fs $syslog
# Required-Stop: $remote_fs $syslog
# Default-Start: 2 3 4 5
# Default-Stop: 0 1 6
# Short-Description: BTSync server daemon
# Description: This service is used to support the bt sync.
# Placed in /etc/init.d.
### END INIT INFO
# Original Author: Nicolas Bernaerts <nicolas.bernaerts@laposte.net>
# Current Author: FOOLMAN <tinyvane@gmail.com>
# Version:
#  Ori V1.0, 06/09/2013 - Creation
#  Ori V1.1, 09/09/2013 - Use under-priviledged system user
#  Cur V1.0, 07/12/2016 - Localized into China Raspberry Pi Users
#  Stop updating. next version is v2.

# description variables
PATH=/sbin:/usr/sbin:/bin:/usr/bin
DESC="BTSync server"
NAME="btsync"
USER=$NAME
DAEMON=/usr/local/sbin/$NAME
ROOT=/home/$NAME
PIDFILE=$ROOT/$NAME.pid
    
# Exit if btsync program is not installed
if [ ! -x "$DAEMON" ] ; then
    echo "Binary $DAEMON does not exist. Aborting"
    exit 0
fi
    
# Exit if btsync user home directory doesn't exist
if [ ! -d "$ROOT" ]; then
    echo "User $USER does not exist. Aborting"
    exit 0
fi
    
# Function that starts the daemon/service
# 0 - daemon started
# 1 - daemon already running
# 2 - daemon could not be started

do_start()
{
    # If needed, start the daemon
    if [ -f "$PIDFILE" ]
    then
        echo "$NAME already running"
        RETVAL="1"
    else
        start-stop-daemon --start --quiet --chuid $USER --name $NAME --exec $DAEMON -- --config /etc/btsync.conf
        RETVAL="$?"
        [ "$RETVAL" = "0" ] && echo "$NAME started"
    fi
        
    return "$RETVAL"
}
    
# Function that stops the daemon/service
# 0 - daemon stopped
# 1 - daemon already stopped
# 2 - daemon could not be stopped

do_stop()
{
    # Stop the daemon
    start-stop-daemon --stop --quiet --retry=TERM/30/KILL/5 --pidfile $PIDFILE --name $NAME
    RETVAL="$?"
    [ "$RETVAL" = "0" ] && echo "$NAME stopped"
    [ "$RETVAL" = "1" ] && echo "$NAME was not running"
        
    # remove pid file
    rm -f $PIDFILE
        
    return "$RETVAL"
}
    
# deal with different parameters : start, stop & status
case "$1" in
    # start service
    start)
        do_start
        ;;
    # stop service
    stop)
        do_stop
        ;;
    # restart service
    restart)
        do_stop
        do_start
        ;;
    # unknown command, display help message
    *)
        echo "Usage : $SCRIPTNAME {start|stop|restart}" >&2
        exit 3
        ;;
esac