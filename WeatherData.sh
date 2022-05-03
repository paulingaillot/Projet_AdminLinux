#!/bin/bash

scp -i /home/pgaill/.ssh/id_rsa pgaill24@10.30.48.100:/tmp/weather.json ./weather.json

temp=`grep -o '"temp":.[^\\]' /home/pgaill/weather.json | sed 's/"temp"://g'`
humidite=`grep -o '"humidity":.[^\\]' /home/pgaill/weather.json | sed 's/"humidity"://g'`
main=`grep -Po '"main":.*?[^*]"' /home/pgaill/weather.json | sed 's/"main":"//g' | sed 's/".*//g'`

city=`grep -Po '"name":.*?[^*]"' /home/pgaill/weather.json | sed 's/"name":"//g' | sed 's/"//g'`

hour=`date +"%H"`

touch "./temp/temp_${hour}.txt"
touch "./humidite/humidite_${hour}.txt"
touch "./main/main_${hour}.txt"

echo $temp >> "./temp/temp_${hour}.txt"
echo $humidite >> "./humidite/humidite_${hour}.txt"
echo $main >> "./main/main_${hour}.txt"
