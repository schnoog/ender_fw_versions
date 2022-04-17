#!/usr/bin/bash




cd /home/pi/FW/

FWS=$( ls |grep -e 'hex\|elf')

echo "Firmware auswählen"	

x=0
i=0
def=""
FLASH=""

for FW in $FWS
do
let i=$i+1
birth=$(stat -c%Z $FW)

if [ $birth -gt $x ]
then
def=$FW
x=$birth
fi


echo "$i ) $FW  - "$(stat -c%z $FW | cut -d '.' -f 1)


done

echo "default: $def"
read tuflash

echo $tuflash

if [ "$tuflash" == "" ]
then
FLASH=$def
else


i=0
for FW in $FWS
do
let i=$i+1
	if [ "$i" == "$tuflash" ]
	then
		FLASH=$FW
	fi 


done




fi



if [ "$FLASH" == "" ]
then
echo "Keine gültige Firmware gewählt"
else
echo "Brenne $FLASH vom "$(stat -c%z $FLASH | cut -d '.' -f 1)
FLASHFILE="/home/pi/FW/$FLASH"

/usr/bin/avrdude -v -q -p m2560 -c wiring -P /dev/ttyUSB0 -D -b 115200 -U flash:w:$FLASHFILE
fi