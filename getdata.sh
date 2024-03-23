#!/bin/bash
export LC_ALL=en_US.UTF-8
LOG="access.log"
ERR="error.log"
PIDFILE="/var/run/sendlog.pid"
h_ago_log="$(date --date="1 hour ago" +"%d/%b/%Y:%H")"
h_ago_err="$(date --date="1 hour ago" +"%Y/%m/%d %H")"
time_current=$(date +"%d/%b/%Y:%H")



if [ -f $PIDFILE ]; then
   echo 'Process is already running with PID '`cat $PIDFILE`
   exit 1
fi

echo $$ > $PIDFILE
trap 'rm $PIDFILE' EXIT

#echo "IPs"
IPS=$(cat $LOG |grep -s "$h_ago_log" |awk '{print $1}' |sort|uniq -c|sort -rn| head -n 10)
# echo $IPS
URLS=$(cat $LOG |grep -s "$h_ago_log" |awk '{print $7}' |sort|uniq -c|sort -rn| head -n 10)
#echo $URLS
CODES=$(cat $LOG |grep -s "$h_ago_log" | awk '{print $9}'| sort | uniq -c | sort -rn | head -n 10)
#echo $CODES
ERRORS=$(cat $ERR |grep -s "$h_ago_err" | head -n 10 | cut -c 1-100)
# echo $ERRORS

MAIL="
Logs (time period: $h_ago_log:00 to $time_current:00)\n
=================Top IPs:=================\n
$IPS\n
=================Top URLs:=================\n
$URLS\n
=================Top Codes:=================\n
$CODES \n
=================Errors:=================\n
$ERRORS \n
"

echo -e $MAIL