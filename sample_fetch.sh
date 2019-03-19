#!/bin/bash

time=$(date "+%Y-%m-%d %H:%M:%S")
echo "execute time : ${time}"

python sample_fetch.py

python clear_sample_not_exist_table.py
while read line
        do
                echo $line
                array=(${line//|||||/ })
                id=${array[0]}
                name=${array[1]}
                lujing=${array[2]}
                ower=${array[3]}
                is_checked=${array[4]}
                FINAL=`echo ${lujing: -1}`
                if [ $FINAL != "/" ]
                then
                lujing=$lujing"/"
                fi
                sh check_sample.sh $lujing $name $ower $id $is_checked

        done < foo.txt

time=$(date "+%Y-%m-%d %H:%M:%S")
echo "finish time : ${time}"

# python get_sample_not_exist