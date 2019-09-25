#!/bin/bash

#Gonzalo Caparros Laiz

# Actualiza lo que hay indicado en el archivo Recursoso.txt con el formato
# $carpeta\t$enlace


if [ ! -f "$1" ]
then
	echo Argumento incorrecto, deben ser un archivo con urls 1>&2
	exit 1
fi


# Primero se descargan todos en una carpeta temporal
ORIGEN=$1

#TEMP=ref
#mkdir $TEMP
#TEMP=$(mktemp -d -p .)



# Montar las carpetas
USER=gonzalo.caparrosl@um.es
MONTAJE=/mnt
CARPETAS=$(cat $ORIGEN | tr '\t' ' ' | tr -s ' ' | cut -d ' ' -f 1)
( cd $MONTAJE; sudo mkdir $CARPETAS )
TEMP=$(mktemp -d -p .)
#( cd $TEMP ; mkdir $CARPETAS )
DATE=$(date -I)






function montar {

	linea=$(cat $ORIGEN | tr '\t' ' ' | tr -s ' ' | head -n $1 | tail -n 1)
	enlace=$(echo $linea | cut -d ' ' -f 2)
	carpeta=$(echo $linea | cut -d ' ' -f 1)
	echo -e "\n\e[1;32mMontando \e[1;34m$MONTAJE/$carpeta\e[0m\n"
	if ! echo $PASS | sudo mount -t davfs $(echo $enlace | tr '\r' ' ') $MONTAJE/$carpeta -o username=$USER > /dev/null
	then
		echo -e "\e[1;31mFallo al montar\e[0m\n"
	fi

}




# pedir contraseña y montar el primero
PASS=""
linea=$(cat $ORIGEN | tr '\t' ' ' | tr -s ' ' | head -n 1 | tail -n 1)
enlace=$(echo $linea | cut -d ' ' -f 2)
carpeta=$(echo $linea | cut -d ' ' -f 1)
falla=true
while $falla
do
	echo -ne "\e[1;32mIntroducir contraseña para \e[1;34m$USER\e[1;32m\nContraseña:"
	read -s PASS
	echo -e "\n\e[1;32mMontando \e[1;34m$MONTAJE/$carpeta\e[0m\n"
	if ! echo $PASS | sudo mount -t davfs $(echo $enlace | tr '\r' ' ') $MONTAJE/$carpeta -o username=$USER > /dev/null
	then
		echo -e "\e[0m\e[1;31mContraseña incorrecta"
	else
		falla=false
	fi
	echo -ne "\e[0m"
done
echo
for i in $(seq 2 $(cat $ORIGEN | wc -l))
do
	montar $i
done







# copiar las carpetas a la carpeta temporal desmotar y borrar las carpetas auxiliares
for c in $CARPETAS
do
	echo -e "\e[1;32mCopiando \e[1;34m$MONTAJE/$c\e[0m"
	cp -vr $MONTAJE/$c $TEMP
	echo -e "\e[1;32mBorrando la carpeta \e[1;34m$TEMP/$c/lost+found\e[0m"
	sudo rmdir $TEMP/$c/lost+found
	echo -e "\e[1;32mDesmontando \e[1;34m$MONTAJE/$c\e[0m"
	sudo umount $MONTAJE/$c
	echo -e "\e[1;32mBorrando la carpeta auxiliar \e[1;34m$MONTAJE/$c\e[0m"
	sudo rmdir $MONTAJE/$c
done






#rep=no
		echo -e "\e[1;44m///////////////////////////////////////////////////////////////////////////////////////////\e[0m"
		echo -e "\e[1;44m////////////////////////////////          INFORME          ////////////////////////////////\e[0m"
		echo -e "\e[1;44m///////////////////////////////////////////////////////////////////////////////////////////\e[0m"



for c in $CARPETAS
do
	## comparar carpetas para ver lo que se ha eliminado y lo que hay nuevo
	if [ ! -d $c/Recursos ]
	then
		mkdir -p $c/Recursos
	fi
	dirdiff $TEMP/$c $c/Recursos > /dev/null
	
#	if [ $rep = no -a \( -f solo1 -o -f solo2 \) ]
#	then
#		echo -e "\e[1;44m///////////////////////////////////////////////////////////////////////////////////////////\e[0m"
#		echo -e "\e[1;44m////////////////////////////////          INFORME          ////////////////////////////////\e[0m"
#		echo -e "\e[1;44m///////////////////////////////////////////////////////////////////////////////////////////\e[0m"
#	fi
	
	## mover lo que se ha borrado
	if [ -f solo2 ]
	then
		mkdir -p $c/recursos_borrados/$DATE
		
		while read l
		do
			aux=$(echo "$l" | cut -d / -f 1,2 --complement)
			aux="$DATE/$aux"
			carpe=$(echo $aux | rev | cut -d / -f 1 --complement | rev)
			mkdir -p $c/recursos_borrados/"$carpe"
			mv "$l" "$c/recursos_borrados/$aux"
			echo -e "\e[1;31m$l \e[1;32mha sido borrado, se guardara en la carpeta \e[1;34m$c/recursos_borrados/$DATE\e[0m"
		done < solo2
		rm solo2
	fi
	
	if [ -f solo1 ]
	then
		echo -e "\e[1;32mLos siguientes archivos son nuevos\e[1;34m"
		while read l
		do
			echo $c/Recursos/$(echo "$l" | cut -d / -f 1,2,3 --complement)
		done < solo1
		rm solo1
		echo -e "\e[0m"
	fi
	
	
	## borrar lo restante
	rm -r $c/Recursos
	
	
	## mover carpetas auxiliares
	mv $TEMP/$c $c/Recursos
	
	
done

rmdir $TEMP


























