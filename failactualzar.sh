#!/bin/bash


# Actualiza lo que hay indicado en el arChivo Recursoso.txt con el formato
# $carpeta\t$enlace

# Primero se descargan todos en una carpeta temporal
TEMP=roof
#mkdir $TEMP

USER=gonzalo.caparrosl@um.es

puntoMontaje=/mnt


while read l
do
	carpeta=$(echo $l | cut -d ' ' -f 1)
	enlace=$(echo $l | cut -d ' ' -f 2)
	echo ----- $enlace   ------------- $carpeta
	#mkdir $TEMP/$carpeta
	#sudo mount -t davfs $enlace $puntoMontaje -o username=$USER
	#cp -vr $puntoMontaje $TEMP
	# renombrar archivo
	#sudo umount $puntoMontaje
done

