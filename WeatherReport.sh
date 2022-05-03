#!/bin/bash

for( i=0; i < 24; i++ );  do
    line=`wc -l ./main/main_${i}.txt | awk 'print $1  }'`
    tot=0
    tab=`echo "./temp/temp_${i}.txt"`
    for( j=0; j < 24; j++ );  do
            tot = tot + tab[j]
    done
    value=tot/line
done


line=`wc -l ./temp/temp_16.txt | awk 'print $1  }'`
for( i=0; i < 24; i++ );  do

done

line=`wc -l ./humidite/humidite_16.txt | awk 'print $1  }'`
for( i=0; i < 24; i++ );  do

done
