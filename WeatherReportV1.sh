#!/bin/bash

printf "# Rapport météorologique de Nantes \n\n" > "/home/pgaill/projet_AdminLinux/reportV1.md"
date=`date +"%d-%m-%Y"`
printf "**Jour**: $date \n" >> "/home/pgaill/projet_AdminLinux/reportV1.md"
printf "**Emplacement**: Nantes (47.21'N,1.55'W)\n\n" >> "/home/pgaill/projet_AdminLinux/reportV1.md"

printf "##Temperature\n\n" >> "/home/pgaill/projet_AdminLinux/reportV1.md"

#! Ciel

printf "| Heure | Température |\n" >> "/home/pgaill/projet_AdminLinux/reportV1.md"
printf "|----------|------------|\n" >> "/home/pgaill/projet_AdminLinux/reportV1.md"

min=100
max=-100
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

        test2=$(awk '{print $2 < $1}' <<< "$min $value" )
        test3=$(awk '{print $2 < $1}' <<< "$value $max" )
        if [ "$test2" -eq "1" ]
        then
                min=$value
        fi
        if [ "$test3" -eq "1" ]
        then
            max=$value
        fi

        printf '|%4s%6s|' "$i" >> "/home/pgaill/projet_AdminLinux/reportV1.md"
        printf '%6.1f%6s|\n' "$value" >> "/home/pgaill/projet_AdminLinux/reportV1.md"

    fi
done
printf "\- **Temperature min**: $min\n">> "/home/pgaill/projet_AdminLinux/reportV1.md"
printf "\- **Temperature max**: $max\n\n" >> "/home/pgaill/projet_AdminLinux/reportV1.md"

printf "\n##Humidite\n\n" >> "/home/pgaill/projet_AdminLinux/reportV1.md"

#! Ciel

printf "| Heure | Humidite |\n" >> "/home/pgaill/projet_AdminLinux/reportV1.md"
printf "|----------|------------|\n" >> "/home/pgaill/projet_AdminLinux/reportV1.md"

min=100
max=-100
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

        test2=$(awk '{print $2 < $1}' <<< "$min $value" )
        test3=$(awk '{print $2 < $1}' <<< "$value $max" )
        if [ "$test2" -eq "1" ]
        then
                min=$value
        fi
        if [ "$test3" -eq "1" ]
        then
            max=$value
        fi

        printf '|%4s%6s|' "$i" >> "/home/pgaill/projet_AdminLinux/reportV1.md"
        printf '%6.1f%6s|\n' "$value" >> "/home/pgaill/projet_AdminLinux/reportV1.md"
    fi
done
printf "\- **Humidite min**: $min\n">> "/home/pgaill/projet_AdminLinux/reportV1.md"
printf "\- **Humidite max**: $max\n\n" >> "/home/pgaill/projet_AdminLinux/reportV1.md"

printf "\n##Ciel\n\n" >> "/home/pgaill/projet_AdminLinux/reportV1.md"

#! Ciel

printf "| Heure | Ciel |\n" >> "/home/pgaill/projet_AdminLinux/reportV1.md"
printf "|----------|------------|\n" >> "/home/pgaill/projet_AdminLinux/reportV1.md"

for i in {1..23}
do
    if [ -f "/home/pgaill/projet_AdminLinux/main/main_${i}.txt" ]; 
    then 
        value=`cat "/home/pgaill/projet_AdminLinux/main/main_${i}.txt"`
        printf '|%4s%6s|' "$i" >> "/home/pgaill/projet_AdminLinux/reportV1.md"
        printf '%6s%6s|\n' "$value" >> "/home/pgaill/projet_AdminLinux/reportV1.md"
    fi
done

if [ -f "/home/pgaill/projet_AdminLinux/main/main_all.txt" ]; 
then 
    `awk -F: '{print $1}' /home/pgaill/projet_AdminLinux/main/main_all.txt | sort | uniq -c | sort -rn | awk '{print $2}' >  /home/pgaill/projet_AdminLinux/main/main_all_sorted.txt`
    meteo=$(head -n 1  /home/pgaill/projet_AdminLinux/main/main_all_sorted.txt)
    printf "\- **Global**: $meteo\n" >> "/home/pgaill/projet_AdminLinux/reportV1.md"
fi

`rm -R ./humidite`
`rm -R ./temp`
`rm -R ./main`