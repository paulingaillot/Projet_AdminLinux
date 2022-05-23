#!/bin/bash

echo "---"> "/home/pgaill/projet_AdminLinux/report.md"
echo "header-includes:">> "/home/pgaill/projet_AdminLinux/report.md"
echo "- \usepackage{fancyhdr}">> "/home/pgaill/projet_AdminLinux/report.md"
echo "- \pagestyle{fancy}">> "/home/pgaill/projet_AdminLinux/report.md"
echo "-  \fancyhead[L]{Rapport Météorologique de Nantes}">> "/home/pgaill/projet_AdminLinux/report.md"
date=`date +"%d-%m-%Y"`
echo "-  \fancyhead[R]{$date}">> "/home/pgaill/projet_AdminLinux/report.md"
echo "-  \fancyfoot[R]{\thepage}">> "/home/pgaill/projet_AdminLinux/report.md"
echo "-  \fancyfoot[CO, CE]{}">> "/home/pgaill/projet_AdminLinux/report.md"
echo "-  \fancyfoot[L]{temperature}">> "/home/pgaill/projet_AdminLinux/report.md"
echo "---">> "/home/pgaill/projet_AdminLinux/report.md"

printf "# Rapport météorologique de Nantes \n\n" >> "/home/pgaill/projet_AdminLinux/report.md"
date=`date +"%d-%m-%Y"`
printf "**Jour**: $date \n\n" >> "/home/pgaill/projet_AdminLinux/report.md" >> "/home/pgaill/projet_AdminLinux/report.md"
printf "**Emplacement**: Nantes (47.21'N,1.55'W)\n\n" >> "/home/pgaill/projet_AdminLinux/report.md"

printf "##Temperature\n\n" >> "/home/pgaill/projet_AdminLinux/report.md"

#! Ciel

printf "| Heure | Température |\n" >> "/home/pgaill/projet_AdminLinux/report.md"
printf "|----------|------------|\n" >> "/home/pgaill/projet_AdminLinux/report.md"

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

        printf '|%4s%6s|' "$i" >> "/home/pgaill/projet_AdminLinux/report.md"
        printf '%6.1f%6s|\n' "$value" >> "/home/pgaill/projet_AdminLinux/report.md"

    fi
done
printf "\- **Temperature min**: $min\n">> "/home/pgaill/projet_AdminLinux/report.md"
printf "\- **Temperature max**: $max\n\n" >> "/home/pgaill/projet_AdminLinux/report.md"

`gnuplot --persist script.txt` 
printf "![](Temp_graph.png)\n" >> "/home/pgaill/projet_AdminLinux/report.md"


printf "\pagebreak  \n">> "/home/pgaill/projet_AdminLinux/report.md"

printf "\n##Humidite\n\n" >> "/home/pgaill/projet_AdminLinux/report.md"

#! Ciel

printf "| Heure | Humidite |\n" >> "/home/pgaill/projet_AdminLinux/report.md"
printf "|----------|------------|\n" >> "/home/pgaill/projet_AdminLinux/report.md"

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

        printf '|%4s%6s|' "$i" >> "/home/pgaill/projet_AdminLinux/report.md"
        printf '%6.1f%6s|\n' "$value" >> "/home/pgaill/projet_AdminLinux/report.md"
    fi
done
printf "\- **Humidite min**: $min\n">> "/home/pgaill/projet_AdminLinux/report.md"
printf "\- **Humidite max**: $max\n\n" >> "/home/pgaill/projet_AdminLinux/report.md"

`gnuplot --persist script2.txt` 
printf "![](Humidite_graph.png)\n" >> "/home/pgaill/projet_AdminLinux/report.md"

printf "\n##Ciel\n\n" >> "/home/pgaill/projet_AdminLinux/report.md"

#! Ciel

printf "| Heure | Ciel |\n" >> "/home/pgaill/projet_AdminLinux/report.md"
printf "|----------|------------|\n" >> "/home/pgaill/projet_AdminLinux/report.md"

for i in {1..23}
do
    if [ -f "/home/pgaill/projet_AdminLinux/main/main_${i}.txt" ]; 
    then 
        value=`cat "/home/pgaill/projet_AdminLinux/main/main_${i}.txt"`
        printf '|%4s%6s|' "$i" >> "/home/pgaill/projet_AdminLinux/report.md"
        printf '%6s%6s|\n' "$value" >> "/home/pgaill/projet_AdminLinux/report.md"
    fi
done

if [ -f "/home/pgaill/projet_AdminLinux/main/main_all.txt" ]; 
then 
    `awk -F: '{print $1}' /home/pgaill/projet_AdminLinux/main/main_all.txt | sort | uniq -c | sort -rn | awk '{print $2}' >  /home/pgaill/projet_AdminLinux/main/main_all_sorted.txt`
    meteo=$(head -n 1  /home/pgaill/projet_AdminLinux/main/main_all_sorted.txt)
    printf "\- **Global**: $meteo\n\n" >> "/home/pgaill/projet_AdminLinux/report.md"
fi

`gnuplot --persist script3.txt` 
printf "![](Main_graph.png)\n" >> "/home/pgaill/projet_AdminLinux/report.md"

`pandoc report.md -o report.pdf`