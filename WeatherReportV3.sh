#!/bin/bash
echo "---"> "/home/pgaill/projet_AdminLinux/report.md"
echo "header-includes:">> "/home/pgaill/projet_AdminLinux/report.md"
echo "- \usepackage{fancyhdr}">> "/home/pgaill/projet_AdminLinux/report.md"
echo "- \pagestyle{fancy}">> "/home/pgaill/projet_AdminLinux/report.md"
echo "-  \fancyhead[L]{Rapport Météorologique de Nantes}">> "/home/pgaill/projet_AdminLinux/report.md"
date=`date +"%d-%m-%Y"`
echo "-  \fancyhead[R]{$date}">> "/home/pgaill/projet_AdminLinux/report.md"
echo "---">> "/home/pgaill/projet_AdminLinux/report.md"


printf "# Rapport météorologique de Nantes \n\n" >> "/home/pgaill/projet_AdminLinux/reportV3.md"
date=`date +"%d-%m-%Y"`
printf "**Jour**: $date \n" >> "/home/pgaill/projet_AdminLinux/reportV3.md" >> "/home/pgaill/projet_AdminLinux/reportV3.md"
printf "**Emplacement**: Nantes (47.21'N,1.55'W)\n\n" >> "/home/pgaill/projet_AdminLinux/reportV3.md"

printf "##Temperature\n\n" >> "/home/pgaill/projet_AdminLinux/reportV3.md"

#! Temperature

`gnuplot --persist -e 'set title "Evolution de la temperature au cours de la journée";set datafile separator ";";set ylabel "°C";set xlabel "Heure";set xdata time;set timefmt "%H:%M";set format x "%H:%M";set grid;set terminal png size 820,450;set output "Temp_graph.png";plot "/home/pgaill/projet_AdminLinux/temp/temp_all.txt" u 1:2 lt rgb "red" w l notitle '` 
printf "![](Temp_graph.png)\n" >> "/home/pgaill/projet_AdminLinux/reportV3.md"

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
    fi
done
printf "\- **Temperature min**: $min\n">> "/home/pgaill/projet_AdminLinux/reportV3.md"
printf "\- **Temperature max**: $max\n\n" >> "/home/pgaill/projet_AdminLinux/reportV3.md"

#! Humidite

printf "\n##Humidite\n\n" >> "/home/pgaill/projet_AdminLinux/reportV3.md"

min=100
max=-100

`gnuplot --persist -e 'set title "Evolution de la temperature au cours de la journée";set datafile sep ";";set ylabel "°C";set xlabel "Heure";set xdata time;set timefmt "%H:%M";set format x "%H:%M";set grid;set autoscale xy;set terminal png size 820,450;set output "Humidite_graph.png";plot "/home/pgaill/projet_AdminLinux/humidite/humidite_all.txt" using 1:2 lt rgb "red" w l notitle'` 
printf "![](Humidite_graph.png)\n" >> "/home/pgaill/projet_AdminLinux/reportV3.md"

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
    fi
done
printf "\- **Humidite min**: $min\n">> "/home/pgaill/projet_AdminLinux/reportV3.md"
printf "\- **Humidite max**: $max\n\n" >> "/home/pgaill/projet_AdminLinux/reportV3.md"



#! Ciel

printf "\n##Ciel\n\n" >> "/home/pgaill/projet_AdminLinux/reportV3.md"


`gnuplot --persist -e 'set title "Evolution de la temperature au cours de la journée";set datafile sep ";";set xlabel "Heure";set xdata time;set timefmt "%H:%M";set format x "%H:%M";set terminal png size 920,650;set output "Main_graph.png";X="" ;Y="";IMG="";storedata(x,y)=(X=X.sprintf(" %f",x),Y=Y."".sprintf(" %s",y),2); plot "/home/pgaill/projet_AdminLinux/main/main_icon.txt" using 1:(storedata($1,stringcolumn(2))) ; set terminal png size 920,200; set output "Main_graph.png" ;plot [3600:86640][1:2] for [i=3600:3600*words(Y):3600] "./icons/".word(Y,(i/3600)).".jpg" binary filetype=jpg center=(3600*word(X,(i/3600)),1.5) dx=45 dy=0.006 with rgbimage notitle '` 
printf "![](Main_graph.png)\n" >> "/home/pgaill/projet_AdminLinux/reportV3.md"


if [ -f "/home/pgaill/projet_AdminLinux/main/main_all.txt" ]; 
then 
    `awk -F: '{print $1}' /home/pgaill/projet_AdminLinux/main/main_all.txt | sort | uniq -c | sort -rn | awk '{print $2}' >  /home/pgaill/projet_AdminLinux/main/main_all_sorted.txt`
    meteo=$(head -n 1  /home/pgaill/projet_AdminLinux/main/main_all_sorted.txt)
    printf "\- **Global**: $meteo\n" >> "/home/pgaill/projet_AdminLinux/reportV3.md"
fi


`pandoc reportV3.md -o report.pdf`


`rm /home/pgaill/projet_AdminLinux/report.md`
`rm /home/pgaill/projet_AdminLinux/Main_graph.png`
`rm /home/pgaill/projet_AdminLinux/Main_graph2.png`
`rm /home/pgaill/projet_AdminLinux/Humidite_graph.png` 
`rm /home/pgaill/projet_AdminLinux/Temp_graph.png` 

#`rm -R ./humidite`
#`rm -R ./temp`
#`rm -R ./main`
