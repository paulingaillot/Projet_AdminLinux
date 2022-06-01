#!/bin/bash
echo "---"> "$HOME/reportV3.md"
echo "header-includes:">> "$HOME/reportV3.md"
echo "- \usepackage{fancyhdr}">> "$HOME/reportV3.md"
echo "- \pagestyle{fancy}">> "$HOME/reportV3.md"
echo "-  \fancyhead[L]{Rapport Météorologique de Nantes}">> "$HOME/reportV3.md"
date=`date +"%d-%m-%Y"`
echo "-  \fancyhead[R]{$date}">> "$HOME/reportV3.md"
echo "---">> "$HOME/reportV3.md"


printf "# Rapport météorologique de Nantes \n\n" >> "$HOME/reportV3.md"
date=`date +"%d-%m-%Y"`
printf "**Jour**: $date \n" >> "$HOME/reportV3.md" >> "$HOME/reportV3.md"

city=`cat $HOME/city.txt`
lat=`cat $HOME/lat.txt`

h="S"
if [[ $lat == *[-]* ]]
then
    lat=`sed "s/-//g" $HOME/lat.txt `
    h="S"
else
    h="N"
fi

lon=`cat $HOME/lon.txt`

l="O"
if [[ $lon == *[-]* ]]
then
    lon=`sed "s/-//g" $HOME/lon.txt`
    l="W"
else
    l="E"
fi

printf "**Emplacement**: $city (%.2f'$h,%.2f'$l)\n\n" "$lat" "$lon" >> "$HOME/reportV3.md"


#! Ciel

printf "\n##Ciel\n\n" >> "$HOME/reportV3.md"


`gnuplot --persist -e 'set title "Evolution du Ciel au cours de la journée";set datafile sep ";";set xlabel "Heure";set xdata time;set timefmt "%H:%M";set format x "%H:%M";set terminal png size 920,650;set output "'$HOME'/Main_graph.png";X="" ;Y="";IMG="";storedata(x,y)=(X=X.sprintf(" %f",x),Y=Y."".sprintf(" %s",y),2); plot "'$HOME'/main/main_icon.txt" using 1:(storedata($1,stringcolumn(2))) ; set terminal png size 920,200; set output "'$HOME'/Main_graph.png" ;plot [3600:86640][1:2] for [i=3600:3600*words(Y):3600] "'$HOME'/icons/".word(Y,(i/3600)).".jpg" binary filetype=jpg center=(3600*word(X,(i/3600)),1.5) dx=45 dy=0.006 with rgbimage notitle '` 
printf "![]($HOME/Main_graph.png)\n" >> "$HOME/reportV3.md"


if [ -f "$HOME/main/main_all.txt" ]; 
then 
    `awk -F: '{print $1}' $HOME/main/main_all.txt | sort | uniq -c | sort -rn | awk '{print $2}' >  $HOME/main/main_all_sorted.txt`
    meteo=$(head -n 1  $HOME/main/main_all_sorted.txt)
    printf "\- **Global**: $meteo\n" >> "$HOME/reportV3.md"
fi

printf "\n##Temperature\n\n" >> "$HOME/reportV3.md"

#! Temperature

`gnuplot --persist -e 'set title "Evolution de la temperature au cours de la journée";set datafile separator ";";set ylabel "°C";set autoscale xy;set xlabel "Heure";set xdata time;set timefmt "%H:%M";set format x "%H:%M";set grid;set terminal png size 820,250;set output "'$HOME'/Temp_graph.png";plot "'$HOME'/temp/temp_all.txt" u 1:2 lt rgb "red" w l notitle '` 
printf "![]($HOME/Temp_graph.png)\n" >> "$HOME/reportV3.md"

min=100
max=-100
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
printf "\- **Temperature min**: %.2f\n" "$min">> "$HOME/reportV3.md"
printf "\- **Temperature max**: %.2f\n\n" "$max">> "$HOME/reportV3.md"

#! Humidite

printf "\n##Humidite\n\n" >> "$HOME/reportV3.md"

min=100
max=-100

`gnuplot --persist -e 'set title "Evolution de l humidité au cours de la journée";set datafile sep ";";set ylabel "%";set xlabel "Heure";set xdata time;set timefmt "%H:%M";set format x "%H:%M";set grid;set terminal png size 820,250;set output "'$HOME'/Humidite_graph.png";plot "'$HOME'/humidite/humidite_all.txt" using 1:2 lt rgb "red" w l notitle'` 
printf "![]($HOME/Humidite_graph.png)\n" >> "$HOME/reportV3.md"

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
printf "\- **Humidite min**: %.2f\n" "$min">> "$HOME/reportV3.md"
printf "\- **Humidite max**: %.2f\n\n" "$max" >> "$HOME/reportV3.md"

date=`date +"%d_%m_%Y"`

`pandoc $HOME/reportV3.md -V geometry:margin=1in -o $HOME/Rapport_Meteo_V3_GAILLOT_$date.pdf`


`rm $HOME/reportV3.md`
`rm $HOME/Main_graph.png`
`rm $HOME/Humidite_graph.png` 
`rm $HOME/Temp_graph.png` 

`rm -R ./humidite`
`rm -R ./temp`
`rm -R ./main`
