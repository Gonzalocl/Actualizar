#!/bin/bash

c=$1
TEMP=$2
MONTAJE=.



COLS=$(tput cols)
let COLS1=COLS-1
let COLS2=COLS-2
function barra {
	let COMPLETADO=$1*$3/$2
	echo -n "["
	printf '=%.0s' $(seq 1 $COMPLETADO)
	echo -ne "\r"
}





	TOTAL=$(find $MONTAJE/$c  2> /dev/null | wc -l)
	COUNT=0
	echo -e "\e[1;32mCopiando \e[1;34m$MONTAJE/$c\e[0m"
	#echo -en "$COUNT/$TOTAL\r"
	mkfifo $TEMP/temp
	cp -vr $MONTAJE/$c $TEMP > $TEMP/temp 2> /dev/null &
	PID=$!
	printf ' %.0s' $(seq 1 $COLS1)
	echo -ne "]\r"
	while read l
	do
		let COUNT++
		#echo -e "progreso $COUNT/$TOTAL\r"
		barra $COUNT $TOTAL $COLS2
	done < $TEMP/temp
	wait $PID
	rm $TEMP/temp
	echo




