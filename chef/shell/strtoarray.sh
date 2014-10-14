#! /bin/bash
#str='battery.charge: 90 battery.charge.low: 30 battery.runtime: 3690 battery.voltage: 230.0 device.mfr: MGE UPS SYSTEMS device.model: Pulsar Evolution 500'
str='name:legacy username:postgres password:root host:localhost drivers:pgsql'


IFS=" " read -a fields <<< "$str"

data='$databases['

for (( i=0 ; i < ${#fields[@]} ; i++ )) ; do
    f=${fields[i]}
    IFS=: read -a vals <<< "$f"
    key=${vals[0]}
    if [ "$key" = "name" ]; then
      data=$data"${vals[1]}'] => array("
    else
      data=$data"'${vals[0]}' => '${vals[1]}',"
    fi 
    #notfirst=$(( i>0 ))
    #last=$(( i+1 == ${#fields[@]} ))

    #(( notfirst )) && echo -n "' => '"${f% *}"', "$'\n'
    #(( !last )) && echo -n "'"${f##* }
    #echo "$f"
    #(( last )) && echo $i
    #start=('' $'\n' ' ')
    #colon=('' ': ')
    #echo -n "${start[notfirst + last]}  dsd sd  ${f##* } => ${colon[!last]}"
done
echo $data
