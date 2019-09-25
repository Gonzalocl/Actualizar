#!/bin/bash

# comparar archovos de dos directorios


if [ ! -d "$1" -o ! -d "$2" ]
then
	echo Argumentos incorrectos, deben ser dos carpetas 1>&2
	exit 1
fi

l1=$(echo -n $1 | wc -c)
let l1=36+l1
l2=$(echo -n $2 | wc -c)
let l2=36+l2

# hacer los md5 de todos los archivos en los directorios quitando 1st carpeta
sums1=$( find $1 -type f -printf 1\  -exec md5sum \{\} \; | cut -c 37-$l1 --complement )
sums2=$( find $2 -type f -printf 2\  -exec md5sum \{\} \; | cut -c 37-$l2 --complement )


# quitar repetidos en la misma carpeta
duplicados1=$(echo "$sums1" | sort -k2 | uniq --all-repeated=separate -s 2 -w 32)
if [ "$duplicados1" != "" ]
then
	echo -e "\e[1;35mLos siguientes archivos estan repetidos en la carpeta \e[1;34m$1\e[0m"
	echo "$duplicados1"
	sums1=$(echo "$sums1" | sort -k2 | uniq -u -s 2 -w 32)
	sums1="$sums1
$(echo "$duplicados1" | uniq -d -s 2 -w 32)"

fi

duplicados2=$(echo "$sums2" | sort -k2 | uniq --all-repeated=separate -s 2 -w 32)
if [ "$duplicados2" != "" ]
then
	echo -e "\e[1;35mLos siguientes archivos estan repetidos en la carpeta \e[1;34m$2\e[0m"
	echo "$duplicados2"
	sums2=$(echo "$sums2" | sort -k2 | uniq -u -s 2 -w 32)
	sums2="$sums2
$(echo "$duplicados2" | uniq -d -s 2 -w 32)"

fi



sums="$sums1
$sums2"


diferentes=$(echo "$sums" | sort -k2 | uniq -u -s 2 -w 32)

modificados=$(echo "$diferentes" | sort -k3 | uniq -d -s 36)
#solo1=$(echo "$diferentes" | sort -k3 | uniq -u -s 36 | grep ^1)
#solo2=$(echo "$diferentes" | sort -k3 | uniq -u -s 36 | grep ^2)
solo1=$(echo "$diferentes" | grep ^1)
solo2=$(echo "$diferentes" | grep ^2)

if [ "$modificados" != "" ]
then
	echo -e "\e[1;35mLos siguientes archivos tiene los mismos nombres pero son diferentes\e[0m"
	echo -e "\e[1;35mSeguardaran en el archivo \e[1;34m\"modificados\"\e[0m"
	echo "$modificados"
	echo "$modificados" > modificados
fi

if [ "$solo1" != "" ]
then
	echo -e "\e[1;35mLos siguientes archivos solo aparecen en el carpeta \e[1;34m$1\e[0m"
	echo -e "\e[1;35mSeguardaran en el archivo \e[1;34m\"solo1\"\e[0m"
	echo "$solo1"
	echo "$solo1" > solo1
fi

if [ "$solo2" != "" ]
then
	echo -e "\e[1;35mLos siguientes archivos solo aparecen en el carpeta \e[1;34m$2\e[0m"
	echo -e "\e[1;35mSeguardaran en el archivo \e[1;34m\"solo2\"\e[0m"
	echo "$solo2"
	echo "$solo2" > solo2
fi



