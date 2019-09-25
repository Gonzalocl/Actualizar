#!/bin/bash


# Actualiza lo que hay indicado en las 5 primeras lineas del archivo Recursoso.txt con el formato
# $carpeta\t$enlace

# Primero se descargan todos en una carpeta temporal
ORIGEN=Recursos.txt

TEMP=ref
mkdir $TEMP

# Montar las carpetas
USER=gonzalo.caparrosl@um.es
MONTAJE=/mnt
CARPETAS=$(cat $ORIGEN | tr '\t' ' ' | tr -s ' ' | cut -d ' ' -f 1)
( cd $MONTAJE; sudo mkdir $CARPETAS )



function montar {

	linea=$(cat $ORIGEN | tr '\t' ' ' | tr -s ' ' | head -n $1 | tail -n 1)
	enlace=$(echo $linea | cut -d ' ' -f 2)
	carpeta=$(echo $linea | cut -d ' ' -f 1)
	falla=true
	while $falla
	do
		echo -e "\e[1;34mMontando \e[35m$MONTAJE/$carpeta\n\e[34mIntroducir contraseña del servidor\e[8m"
		if ! sudo mount -t davfs $(echo $enlace | tr '\r' ' ') $MONTAJE/$carpeta -o username=$USER
		then
			echo -e "\e[0m\e[1;31mContraseña incorrecta"
		else
			falla=false
		fi
		echo -ne "\e[0m"
	done

}

for i in $(seq 1 $(cat $ORIGEN | wc -l))
do
	montar $i
done


# copiar las carpetas a la carpeta temporal desmotar y borrar las carpetas auxiliares

for c in $CARPETAS
do
	echo -e "\e[1;36mCopiando \e[35m$MONTAJE/$c\e[0m"
	cp -vr $MONTAJE/$c $TEMP
	echo -e "\e[1;36mDesmontando \e[35m$MONTAJE/$c\e[0m"
	sudo umount $MONTAJE/$c
	echo -e "\e[1;36mBorrando la carpeta auxiliar \e[35m$MONTAJE/$c\e[0m"
	sudo rmdir $MONTAJE/$c
done






