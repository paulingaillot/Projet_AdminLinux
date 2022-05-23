#!/bin/bash

 wget "https://api.openweathermap.org/data/2.5/onecall?lat=47.218371&lon=-1.553621&appid=ee4bbad0fcec46876c73fa6ad4faec06" --output-document="/home/pgaill/projet_AdminLinux/weatherexept.json"
 wget "https://api.openweathermap.org/data/2.5/forecast?lat=47.218371&lon=-1.553621&appid=ee4bbad0fcec46876c73fa6ad4faec06" --output-document="/home/pgaill/projet_AdminLinux/weatherexept2.json"


tabtemp=`jq .hourly[].temp weatherexept.json`
tabhumid=`jq .hourly[].humidity weatherexept.json`

printf "# Rapport météorologique de Nantes \n\n" > "/home/pgaill/projet_AdminLinux/reportexept.md"
date=`date +"%d-%m-%Y"`
printf "**Jour**: $date \n" >> "/home/pgaill/projet_AdminLinux/reportexept.md"
printf "**Emplacement**: Nantes (47.21'N,1.55'W)\n\n" >> "/home/pgaill/projet_AdminLinux/reportexept.md"

printf "##Temps sur 48 Heures\n\n" >> "/home/pgaill/projet_AdminLinux/reportexept.md"
#! Ciel

printf "|%14s Heure %14s| Température |%3s Humidite |\n" >> "/home/pgaill/projet_AdminLinux/reportexept.md"
printf "|-----------------------------------|-------------|-------------|\n" >> "/home/pgaill/projet_AdminLinux/reportexept.md"

echo "" > "/home/pgaill/projet_AdminLinux/except_all.txt"


for i in {0..47}
do
    temp=`jq .hourly[$i].temp weatherexept.json`
    temp=$(awk '{print $1-$2}' <<<"${temp} 273.15")
    humid=`jq .hourly[$i].humidity weatherexept.json`
    dt=`jq .hourly[$i].dt weatherexept.json`
    
    date=`date -d @$((($dt))) +"%d/%m-%H:%M"`

    printf '|%32s%3s|' "$date" >> "/home/pgaill/projet_AdminLinux/reportexept.md"
    printf '%7.1f%6s|' "$temp" >> "/home/pgaill/projet_AdminLinux/reportexept.md"
    printf '%7.1f%6s|\n' "$humid" >> "/home/pgaill/projet_AdminLinux/reportexept.md"

    echo "$date;$temp;$humid" >> "/home/pgaill/projet_AdminLinux/except_all.txt"
done



`gnuplot --persist script4.txt` 
printf "![](Except_graph.png)\n" >> "/home/pgaill/projet_AdminLinux/reportexept.md"
printf "![](Except2_graph.png)\n" >> "/home/pgaill/projet_AdminLinux/reportexept.md"

printf "\pagebreak \n">> "/home/pgaill/projet_AdminLinux/reportexept.md"

printf "\n##Temps sur 5 Jours\n\n" >> "/home/pgaill/projet_AdminLinux/reportexept.md"

printf "|%14s Date %14s| Température |%3s Humidite |\n" >> "/home/pgaill/projet_AdminLinux/reportexept.md"
printf "|-----------------------------------|-------------|-------------|\n" >> "/home/pgaill/projet_AdminLinux/reportexept.md"


echo "" > "/home/pgaill/projet_AdminLinux/except3_all.txt"
for i in {0..39}
do 
temp=`jq .list[$i].main.temp weatherexept2.json`
    temp=$(awk '{print $1-$2}' <<<"${temp} 273.15")
    humid=`jq .list[$i].main.humidity weatherexept2.json`
    dt=`jq .list[$i].dt weatherexept2.json`
    
    date=`date -d @$((($dt))) +"%d/%m-%H:%M"`

    printf '|%32s%3s|' "$date" >> "/home/pgaill/projet_AdminLinux/reportexept.md"
    printf '%7.1f%6s|' "$temp" >> "/home/pgaill/projet_AdminLinux/reportexept.md"
    printf '%7.1f%6s|\n' "$humid" >> "/home/pgaill/projet_AdminLinux/reportexept.md"

    echo "$date;$temp;$humid" >> "/home/pgaill/projet_AdminLinux/except3_all.txt"
done


`gnuplot --persist script6.txt` 
printf "![](Except3_graph.png)\n" >> "/home/pgaill/projet_AdminLinux/reportexept.md"
printf "![](Except32_graph.png)\n" >> "/home/pgaill/projet_AdminLinux/reportexept.md"


printf "\pagebreak \n">> "/home/pgaill/projet_AdminLinux/reportexept.md"

printf "\n##Temps sur 7 Jours\n\n" >> "/home/pgaill/projet_AdminLinux/reportexept.md"

printf "|%14s Date %14s| Température |%3s Humidite |\n" >> "/home/pgaill/projet_AdminLinux/reportexept.md"
printf "|-----------------------------------|-------------|-------------|\n" >> "/home/pgaill/projet_AdminLinux/reportexept.md"


echo "" > "/home/pgaill/projet_AdminLinux/except2_all.txt"
for i in {0..7}
do 
temp=`jq .daily[$i].temp.day weatherexept.json`
    temp=$(awk '{print $1-$2}' <<<"${temp} 273.15")
    humid=`jq .daily[$i].humidity weatherexept.json`
    dt=`jq .daily[$i].dt weatherexept.json`
    
    date=`date -d @$((($dt))) +"%d/%m"`

    printf '|%32s%3s|' "$date" >> "/home/pgaill/projet_AdminLinux/reportexept.md"
    printf '%7.1f%6s|' "$temp" >> "/home/pgaill/projet_AdminLinux/reportexept.md"
    printf '%7.1f%6s|\n' "$humid" >> "/home/pgaill/projet_AdminLinux/reportexept.md"

    echo "$date;$temp;$humid" >> "/home/pgaill/projet_AdminLinux/except2_all.txt"
done


`gnuplot --persist script5.txt` 
printf "![](Except1_graph.png)\n" >> "/home/pgaill/projet_AdminLinux/reportexept.md"
printf "![](Except12_graph.png)\n" >> "/home/pgaill/projet_AdminLinux/reportexept.md"

`pandoc reportexept.md -o reportexept.pdf`