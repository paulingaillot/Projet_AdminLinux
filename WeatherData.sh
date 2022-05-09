#!/bin/bash

`scp -i /home/pgaill/.ssh/id_rsa pgaill24@10.30.48.100:/tmp/weather.json /home/pgaill/projet_AdminLinux/weather.json`

temp=`grep -o '"temp":.[^\\]' /home/pgaill/projet_AdminLinux/weather.json | sed 's/"temp"://g'`
humidite=`grep -o '"humidity":.[^\\]' /home/pgaill/projet_AdminLinux//weather.json | sed 's/"humidity"://g'`
main=`grep -Po '"main":.*?[^*]"' /home/pgaill/projet_AdminLinux/weather.json | sed 's/"main":"//g' | sed 's/".*//g'`

city=`grep -Po '"name":.*?[^*]"' /home/pgaill/projet_AdminLinux/weather.json | sed 's/"name":"//g' | sed 's/"//g'`

hour=`date +"%H"`

touch "/home/pgaill/projet_AdminLinux/temp/temp_${hour}.txt"
touch "/home/pgaill/projet_AdminLinux/humidite/humidite_${hour}.txt"
touch "/home/pgaill/projet_AdminLinux/main/main_${hour}.txt"

echo $temp >> "/home/pgaill/projet_AdminLinux/temp/temp_${hour}.txt"
echo $humidite >> "/home/pgaill/projet_AdminLinux/humidite/humidite_${hour}.txt"
echo $main >> "/home/pgaill/projet_AdminLinux/main/main_${hour}.txt"
