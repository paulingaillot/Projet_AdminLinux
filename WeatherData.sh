#!/bin/bash

`scp -i $HOME/.ssh/id_rsa pgaill24@10.30.48.100:/tmp/weather.json $HOME/weather.json`
#wget "https://api.openweathermap.org/data/2.5/weather?lat=47.218371&lon=-1.553621&appid=ee4bbad0fcec46876c73fa6ad4faec06" --output-document="$HOME/weather.json"

temp=`grep -Po '"temp":.*?[^*],' $HOME/weather.json | sed 's/"temp"://g' | sed 's/,//g'`
temp=$(awk '{print $1-$2}' <<<"${temp} 273.15")
humidite=`grep -o '"humidity":.[^\\]' $HOME//weather.json | sed 's/"humidity"://g'`
icon=` grep -Po '"icon":.*?[^*]"' $HOME/weather.json | sed 's/"icon"://g' | sed 's/"//g'`

min=$(date +"%M" | sed "s/ //g")

city=`grep -Po '"name":.*?[^*]"' $HOME/weather.json | sed 's/"name":"//g' | sed 's/"//g'`
lat=`grep -Po '"lat":.*?[^*]}' $HOME/weather.json | sed 's/"lat"://g' | sed 's/}//g'`
lon=`grep -Po '"lon":.*?[^*],' $HOME/weather.json| sed 's/"lon"://g' | sed 's/,//g'`

`echo $city > $HOME/city.txt`
`echo $lat > $HOME/lat.txt`
`echo $lon > $HOME/lon.txt`

hour=$(date +"%k" | sed "s/ //g")

moment=`date +"%H:%M"`

if [ ! -f "$HOME/main/main_icon.txt" ];
then
    `mkdir $HOME/main/`
    `touch "$HOME/main/main_icon.txt"`
fi

if [ ! -f "$HOME/temp/temp_all.txt" ];
then
    `mkdir $HOME/temp/`
    
fi

if [ ! -f "$HOME/humidite/humidite_all.txt" ];
then
    `mkdir $HOME/humidite/`
fi


if ((min < 5));
then
    main=`grep -Po '"main":.*?[^*]"' $HOME/weather.json | sed 's/"main":"//g' | sed 's/".*//g'`
    touch "$HOME/main/main_${hour}.txt"
    echo $main >> "$HOME/main/main_${hour}.txt"
    echo $main >> "$HOME/main/main_all.txt"
    echo "$moment;$icon" >> "$HOME/main/main_icon.txt"
fi 


touch "$HOME/temp/temp_${hour}.txt"
touch "$HOME/humidite/humidite_${hour}.txt"

echo $temp >> "$HOME/temp/temp_${hour}.txt"

echo "$moment;$temp" >> "$HOME/temp/temp_all.txt"


echo $humidite >> "$HOME/humidite/humidite_${hour}.txt"
echo "$moment;$humidite" >> "$HOME/humidite/humidite_all.txt"

# Rapport Partiel 


printf "# Rapport météorologique de Nantes \n\n" > "$HOME/uncomplete_report.md"
date=`date +"%d-%m-%Y"`
printf "**Jour**: $date \n" >> "$HOME/uncomplete_report.md"
printf "**Emplacement**: Nantes (47.21°N,1.55°W)\n\n" >> "$HOME/uncomplete_report.md"

printf "##Temperature\n\n" >> "$HOME/uncomplete_report.md"

#! Ciel

printf "| Heure | Température |\n" >> "$HOME/uncomplete_report.md"
printf "|----------|------------|\n" >> "$HOME/uncomplete_report.md"

for i in {1..23}
do
    if [ -f "$HOME/temp/temp_${i}.txt" ]; 
    then 
        line=`wc -l $HOME/temp/temp_${i}.txt | awk '{print $1  }'`
        tot=0
        tab=`cat "$HOME/temp/temp_${i}.txt"`
    
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

        printf '|%4s%6s|' "$i" >> "$HOME/uncomplete_report.md"
        printf '%6.1f%6s|\n' "$value" >> "$HOME/uncomplete_report.md"
    fi
done


printf "\n##Humidite\n\n" >> "$HOME/uncomplete_report.md"

#! Ciel

printf "| Heure | Humidite |\n" >> "$HOME/uncomplete_report.md"
printf "|----------|------------|\n" >> "$HOME/uncomplete_report.md"

for i in {1..23}
do
    if [ -f "$HOME/humidite/humidite_${i}.txt" ]; 
    then
        line=`wc -l $HOME/humidite/humidite_${i}.txt | awk '{print $1  }'`
        tot=0
        tab=`cat "$HOME/humidite/humidite_${i}.txt"`
    
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

        printf '|%4s%6s|' "$i" >> "$HOME/uncomplete_report.md"
        printf '%6.1f%6s|\n' "$value" >> "$HOME/uncomplete_report.md"
    fi
done


printf "\n##Ciel\n\n" >> "$HOME/uncomplete_report.md"

#! Ciel

printf "| Heure | Ciel |\n" >> "$HOME/uncomplete_report.md"
printf "|----------|------------|\n" >> "$HOME/uncomplete_report.md"

for i in {1..23}
do
    if [ -f "$HOME/main/main_${i}.txt" ]; 
    then 
        value=`cat "$HOME/main/main_${i}.txt"`
        printf '|%4s%6s|' "$i" >> "$HOME/uncomplete_report.md"
        printf '%6s%6s|\n' "$value" >> "$HOME/uncomplete_report.md"
    fi
done





