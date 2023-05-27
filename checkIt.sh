#!/bin/bash

clear
echo '######################################################################################'
echo "script writen by SaltedCrackerJack JTWP.org joins my discord if u have any problems "
echo '######################################################################################'
sleep 1
rm ERROR.log

read -p "your rcon passwords will be displayed here to check for errors is that ok (y/n)?" choice
case "$choice" in
  y|Y ) echo script will contine now ;;
  n|N ) exit 0 ;;
  * ) echo "invalid";;
esac
echo "as a note the logs will not show passwords in the event u need to share them but passwords will show on this screen at some points "


echo
echo " detecting all pavlovserver installs "
sleep .5
echo
services=( $(grep '/PavlovServer.sh' /etc/systemd/system/*.service | awk '{print $1}' | awk -F "\/" '{print $5}' | awk -F ":" '{print $1}' | awk -F "." '{print $1}') )
dirs=( $(grep -B1 '/PavlovServer.sh' /etc/systemd/system/*.service | grep 'WorkingDirectory' | awk -F "/" '{print $6"/"$7"/"$8}') )
echo
#LOOKING FOR PORTS ON SERVERS
grep '/PavlovServer.sh' /etc/systemd/system/*.service | awk '{print $2}' | awk -F "'" '{print $2}' > ports.tmp
sed -i -e 's/^$/PORT-ERROR/' ports.tmp
ports=( $(cat ports.tmp) )

echo " done . "
echo " there where $(echo $(( ${#services[@]}+1 )) ) servers detected "
echo

for index in ${!services[*]}; do
        echo
        echo "SERVER REPORT ; "
        echo " SERVICENAME: ${services[$index]}  DIRECTORIES: ${dirs[$index]} RCON-PORT: ${ports[$index]}  "
        systemctl status ${services[$index]} | grep Active
        echo
done | tee serverReport.log

grep "ERROR" serverReport.log >> ERROR.log
