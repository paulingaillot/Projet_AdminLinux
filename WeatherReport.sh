#!/bin/bash

#! Ciel

echo "Ciel"

for i in {1..23}
do
    line=`wc -l ./main/main_${i}.txt | awk '{print $1  }'`
    tot=0
    tab=`cat "./main/main_${i}.txt"`
    for j in line
    do
            tot=tot+tab[j]
    done
    value=tot/line
done

#! Temperature

echo "Temperature"

for i in {1..23}
do
    if [ -f "./temp/temp_${i}.txt" ]; 
    then 
        line=`wc -l ./temp/temp_${i}.txt | awk '{print $1  }'`
        tot=0
        tab=`cat "./temp/temp_${i}.txt"`
    
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
        printf "$i h : $value\n"
    fi
done

#!humidite


echo "Humidite"

for i in {1..23}
do
    if [ -f "./temp/temp_${i}.txt" ]; 
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
        printf "$i h : $value \n"
    fi
done

