APP_NAME=${project.artifactId}
APP_LONG_NAME=${project.name}
APP_VERSION=${project.version}
APP_PACKAGING=${project.packaging}

LOG_PATH="${HOME}/springboot_logs/${APP_NAME}"
LOG_FILE="${APP_LONG_NAME}.log"

JAVA_HOME=${JAVA_HOME}
JAVA_CMD="java"
JAVA_OPTS="-Duser.timezone=Asia/Hong_Kong"
JAVA_AGENT=""
CURRENT_DATE=`date +%Y-%m-%d`
PIDDIR="."
PIDFILE="$PIDDIR/app.pid"
#######################################################
###----------DO NOT EDIT BEYOND THIS LINE-----------###
#######################################################
clear

pid=""
#ps command location
PSEXE="/bin/ps"
if [ ! -x $PSEXE ]
then
echo "Unable to locate ps command at $PSEXE"
echo "Please check correct location of ps command and update PSEXE path"
echo "Please check correct location of ps command and update PSEXE path. Trying to use system ps command."
PSEXE="ps"
fi

getpid(){
if [ -r $PIDFILE ]
then
pid=`cat "$PIDFILE"`
if [ "X$pid" != "X" ]
then
psres=`$PSEXE -fp $pid | grep $APP_NAME | tail -1`
if [ "X$psres" = "X" ]
then
echo "pid not running. Removing stale pid file"
rm -f $PIDFILE
pid=""
fi
fi
else
echo "No existing accessible pid file"
fi

}

start(){
mkdir -p $LOG_PATH
nohup $JAVA_CMD $JAVA_OPTS $JAVA_AGENT -jar $APP_NAME-$APP_VERSION.$APP_PACKAGING >> $LOG_PATH/$LOG_FILE 2>&1 &
echo -e "Started $APP_LONG_NAME. View logs at ${LOG_PATH}/${LOG_FILE}"
}

stop(){
getpid
if [ "X$pid" = "X" ]
then
echo -e "\nApplication $APP_LONG_NAME not running"
else
kill $pid
rm -f $PIDFILE
echo -e "\nSuccessfully stopped $APP_LONG_NAME"
fi
}

case $1 in

start)
echo "Starting $APP_LONG_NAME"
getpid
if [ "X$pid" = "X" ]
then
echo -e "\n$APP_LONG_NAME not running. Starting $APP_LONG_NAME...\n\n"
start
else
echo -e "\nUnable to start. Application already running"
fi
;;
stop)
echo "Stopping $APP_LONG_NAME"
stop
;;
status)
echo "Checking status of $APP_LONG_NAME"
getpid
if [ "X$pid" = "X" ]
then
echo -e "\nApplication $APP_LONG_NAME is NOT RUNNING"
else
echo -e "\nApplication $APP_LONG_NAME is RUNNING"
fi
;;
restart)
echo "Restarting $APP_LONG_NAME"
stop
start
;;
*)

echo "Usage:$0 {start|stop|restart|status}"
esac