#!/bin/bash


printf "# Rapport météorologique de Nantes \n\n" >> "/home/pgaill/projet_AdminLinux/report.md"
date=`date +"%d-%m-%Y"`
printf "**Jour**: $date \n" >> "/home/pgaill/projet_AdminLinux/report.md" >> "/home/pgaill/projet_AdminLinux/report.md"
printf "**Emplacement**: Nantes (47.21°N,1.55°W)\n\n" >> "/home/pgaill/projet_AdminLinux/report.md"

printf "##Temperature\n\n" >> "/home/pgaill/projet_AdminLinux/report.md"

#! Ciel

printf "| Heure | Température |\n" >> "/home/pgaill/projet_AdminLinux/report.md"
printf "|-------|-------------|\n" >> "/home/pgaill/projet_AdminLinux/report.md"


for i in {1..23}
do
    if [ -f "./temp/temp_${i}.txt" ]; 
    then 
        line=`wc -l ./temp/temp_${i}.txt | awk '{print $1  }'`
        tot=0
        tab=`cat "./temp/temp_${i}.txt"`
    
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
        printf '|%8s%10s|' "$i" >> "/home/pgaill/projet_AdminLinux/report.md"
        printf '|%8s%10s|\n' "$value" >> "/home/pgaill/projet_AdminLinux/report.md"
    fi
done



printf "\n##Humidite\n\n" >> "/home/pgaill/projet_AdminLinux/report.md"

#! Ciel

printf "| Heure | Humidite |\n" >> "/home/pgaill/projet_AdminLinux/report.md"
printf "|-------|-------------|\n" >> "/home/pgaill/projet_AdminLinux/report.md"

for i in {1..23}
do
    if [ -f "./humidite/humidite_${i}.txt" ]; 
    then
        line=`wc -l ./humidite/humidite_${i}.txt | awk '{print $1  }'`
        tot=0
        tab=`cat "./humidite/humidite_${i}.txt"`
    
        for j in ${tab[*]}
        do
                tot=$(($tot + $j))
        done


        if((line != 0)) 
        then
            value=$((tot / line))
        else 
            value='0'
        fi
        printf '|%8s%10s|' "$i" >> "/home/pgaill/projet_AdminLinux/report.md"
        printf '|%8s%10s|\n' "$value" >> "/home/pgaill/projet_AdminLinux/report.md"
    fi
done

printf "\n##Ciel\n\n" >> "/home/pgaill/projet_AdminLinux/report.md"

#! Ciel

printf "| Heure | Ciel |\n" >> "/home/pgaill/projet_AdminLinux/report.md"
printf "|-------|-------------|\n" >> "/home/pgaill/projet_AdminLinux/report.md"

for i in {1..23}
do
    if [ -f "./temp/temp_${i}.txt" ]; 
    then 
        value=`cat "./main/main_${i}.txt"`
        printf '|%8s%10s|' "$i" >> "/home/pgaill/projet_AdminLinux/report.md"
        printf '|%8s%10s|\n' "$value" >> "/home/pgaill/projet_AdminLinux/report.md"
    fi
done

#! Temperature

echo "Temperature"


#!humidite


echo "Humidite"



