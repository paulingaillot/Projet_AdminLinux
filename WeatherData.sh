#!/bin/bash

#`scp -i /home/pgaill/.ssh/id_rsa pgaill24@10.30.48.100:/tmp/weather.json /home/pgaill/projet_AdminLinux/weather.json`
 wget "https://api.openweathermap.org/data/2.5/weather?lat=47.218371&lon=-1.553621&appid=ee4bbad0fcec46876c73fa6ad4faec06" --output-document=weather.json

temp=`grep -Po '"temp":.*?[^*],' /home/pgaill/projet_AdminLinux/weather.json | sed 's/"temp"://g' | sed 's/,//g'`
temp=$(awk '{print $1-$2}' <<<"${temp} 273.15")
humidite=`grep -o '"humidity":.[^\\]' /home/pgaill/projet_AdminLinux//weather.json | sed 's/"humidity"://g'`

min=$(date +"%M" | sed "s/ //g")

city=`grep -Po '"name":.*?[^*]"' /home/pgaill/projet_AdminLinux/weather.json | sed 's/"name":"//g' | sed 's/"//g'`

hour=$(date +"%k" | sed "s/ //g")

if ((min < 5));
then
    main=`grep -Po '"main":.*?[^*]"' /home/pgaill/projet_AdminLinux/weather.json | sed 's/"main":"//g' | sed 's/".*//g'`
    touch "/home/pgaill/projet_AdminLinux/main/main_${hour}.txt"
    echo $main >> "/home/pgaill/projet_AdminLinux/main/main_${hour}.txt"
    echo $main >> "/home/pgaill/projet_AdminLinux/main/main_all.txt"
fi 

touch "/home/pgaill/projet_AdminLinux/temp/temp_${hour}.txt"
touch "/home/pgaill/projet_AdminLinux/humidite/humidite_${hour}.txt"

echo $temp >> "/home/pgaill/projet_AdminLinux/temp/temp_${hour}.txt"

moment=`date +"%H:%M"`
echo "$moment;$temp" >> "/home/pgaill/projet_AdminLinux/temp/temp_all.txt"


echo $humidite >> "/home/pgaill/projet_AdminLinux/humidite/humidite_${hour}.txt"
echo "$moment;$humidite" >> "/home/pgaill/projet_AdminLinux/humidite/humidite_all.txt"

# Rapport Partiel 


printf "# Rapport météorologique de Nantes \n\n" > "/home/pgaill/projet_AdminLinux/uncomplete_report.md"
date=`date +"%d-%m-%Y"`
printf "**Jour**: $date \n" >> "/home/pgaill/projet_AdminLinux/uncomplete_report.md"
printf "**Emplacement**: Nantes (47.21°N,1.55°W)\n\n" >> "/home/pgaill/projet_AdminLinux/uncomplete_report.md"

printf "##Temperature\n\n" >> "/home/pgaill/projet_AdminLinux/uncomplete_report.md"

#! Ciel

printf "| Heure | Température |\n" >> "/home/pgaill/projet_AdminLinux/uncomplete_report.md"
printf "|----------|------------|\n" >> "/home/pgaill/projet_AdminLinux/uncomplete_report.md"

for i in {1..23}
do
    if [ -f "/home/pgaill/projet_AdminLinux/temp/temp_${i}.txt" ]; 
    then 
        line=`wc -l /home/pgaill/projet_AdminLinux/temp/temp_${i}.txt | awk '{print $1  }'`
        tot=0
        tab=`cat "/home/pgaill/projet_AdminLinux/temp/temp_${i}.txt"`
    
        for j in ${tab[*]}
        do
            tot=$(awk '{print $1+$2}' <<<"${tot} $j}")
        done
      
        if((line != 0)) 
        then
            value=$(awk '{print $1/$2}' <<<"${tot} $line}")
        else 
            value='0'
        fi

        printf '|%4s%6s|' "$i" >> "/home/pgaill/projet_AdminLinux/uncomplete_report.md"
        printf '%6.1f%6s|\n' "$value" >> "/home/pgaill/projet_AdminLinux/uncomplete_report.md"
    fi
done


printf "\n##Humidite\n\n" >> "/home/pgaill/projet_AdminLinux/uncomplete_report.md"

#! Ciel

printf "| Heure | Humidite |\n" >> "/home/pgaill/projet_AdminLinux/uncomplete_report.md"
printf "|----------|------------|\n" >> "/home/pgaill/projet_AdminLinux/uncomplete_report.md"

for i in {1..23}
do
    if [ -f "/home/pgaill/projet_AdminLinux/humidite/humidite_${i}.txt" ]; 
    then
        line=`wc -l /home/pgaill/projet_AdminLinux/humidite/humidite_${i}.txt | awk '{print $1  }'`
        tot=0
        tab=`cat "/home/pgaill/projet_AdminLinux/humidite/humidite_${i}.txt"`
    
        for j in ${tab[*]}
        do
                tot=$(($tot + $j))
        done


        if((line != 0)) 
        then
             value=$(awk '{print $1/$2}' <<<"${tot} $line}")
        else 
            value='0'
        fi

        printf '|%4s%6s|' "$i" >> "/home/pgaill/projet_AdminLinux/uncomplete_report.md"
        printf '%6.1f%6s|\n' "$value" >> "/home/pgaill/projet_AdminLinux/uncomplete_report.md"
    fi
done


printf "\n##Ciel\n\n" >> "/home/pgaill/projet_AdminLinux/uncomplete_report.md"

#! Ciel

printf "| Heure | Ciel |\n" >> "/home/pgaill/projet_AdminLinux/uncomplete_report.md"
printf "|----------|------------|\n" >> "/home/pgaill/projet_AdminLinux/uncomplete_report.md"

for i in {1..23}
do
    if [ -f "/home/pgaill/projet_AdminLinux/main/main_${i}.txt" ]; 
    then 
        value=`cat "/home/pgaill/projet_AdminLinux/main/main_${i}.txt"`
        printf '|%4s%6s|' "$i" >> "/home/pgaill/projet_AdminLinux/uncomplete_report.md"
        printf '%6s%6s|\n' "$value" >> "/home/pgaill/projet_AdminLinux/uncomplete_report.md"
    fi
done





