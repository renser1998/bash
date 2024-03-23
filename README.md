# bash


# Проверяем, не запущен ли уже процесс. Плюс отлавливаем закрытие, чтобы после себя подчистить pid файл
```shell
if [ -f $PIDFILE ]; then
   echo 'Process is already running with PID '`cat $PIDFILE`
   exit 1
fi
echo $$ > $PIDFILE
trap 'rm $PIDFILE' EXIT
```
# Читаем логи и парсим нужные поля
```shell
IPS=$(cat $LOG |grep -s "$h_ago_log" |awk '{print $1}' |sort|uniq -c|sort -rn| head -n 10)
# echo $IPS
URLS=$(cat $LOG |grep -s "$h_ago_log" |awk '{print $7}' |sort|uniq -c|sort -rn| head -n 10)
#echo $URLS
CODES=$(cat $LOG |grep -s "$h_ago_log" | awk '{print $9}'| sort | uniq -c | sort -rn | head -n 10)
#echo $CODES
ERRORS=$(cat $ERR |grep -s "$h_ago_err" | head -n 10 | cut -c 1-100)
```
# Формирование сообщения + имитация отправки
```shell
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
```
