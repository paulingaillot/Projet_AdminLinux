#!/bin/bash

scp -i /home/pgaill/.ssh/id_rsa pgaill24@10.30.48.100:/tmp/weather.json ./weather.json

temp=`grep -o '"temp":.[^\\]' /home/pgaill/weather.json | sed 's/"temp"://g'`
humidite=`grep -o '"humidity":.[^\\]' /home/pgaill/weather.json | sed 's/"humidity"://g'`


echo ${tab[*]}
