#! /bin/bash
#str='battery.charge: 90 battery.charge.low: 30 battery.runtime: 3690 battery.voltage: 230.0 device.mfr: MGE UPS SYSTEMS device.model: Pulsar Evolution 500'
str='name:legacy username:postgres password:root host:localhost drivers:pgsql'


IFS=" " read -a fields <<< "$str"

s='$databases['
d=''
e='),);'
a=''
for (( i=0 ; i < ${#fields[@]} ; i++ )) ; do
    f=${fields[i]}
    IFS=: read -a vals <<< "$f"
    key=${vals[0]}
    if [ "$key" = "name" ]; then
      s=$s"${vals[1]}'] => array('default' => array("
    else
      d=$d"'${vals[0]}' => '${vals[1]}',"
    fi 
    last=$(( i+1 == ${#fields[@]} ))
    if [ last ]; then
      a=$s$d$e
    fi
done
echo $a
