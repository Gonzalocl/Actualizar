#!/bin/bash


# Actualiza lo que hay indicado en las 5 primeras lineas del archivo Recursoso.txt con el formato
# $carpeta\t$enlace

# Primero se descargan todos en una carpeta temporal
TEMP=roof
#mkdir $TEMP

# Montar las carpetas
USER=gonzalo.caparrosl@um.es
MONTAJE=/mnt
CARPETAS=$(cat Recursos.txt | tr '\t' ' ' | tr -s ' ' | cut -d ' ' -f 1)
#( cd $MONTAJE; sudo mkdir $CARPETAS )

linea=$(cat Recursos.txt | head -n 1 | tail -n 1)
echo ----linea---- $linea
enlace=$(echo $linea | cut -d ' ' -f 2)
carpeta=$(echo $linea | cut -d ' ' -f 1)
echo ----enlace------- $enlace -------car------- $carpeta

exit
sudo mount -t davfs $enlace $MONTAJE/$carpeta -o username=$USER











exit

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

