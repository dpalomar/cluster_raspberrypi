#!/bin/bash

if [[ "$USER" != "root" ]]; then
	echo -e "Este script se debe ejecutar como root\n"
	exit 1
fi

while getopts "d:n:m:i:" PARM
do
	
	case "$PARM" in
		d)
			DISP=$OPTARG
			;;
		
                n)
			NM=$OPTARG
			;;
		

                m)
			PTH=$OPTARG
			;;
                
		i)
			ISO=$OPTARG
			;;
		
                *)
			echo -e "Debe introducir el dispositivo donde se encuentra la tarjeta SD\n \ 
, el número de tarjetas SD y un directorio de montaje"
			exit 1
			;;
	esac
done


if [[ $OPTIND -eq 1 ]]; then
			
    echo -e "Debe introducir el dispositivo donde se encuentra la tarjeta SD\n \ 
, el número de tarjetas SD y un directorio de montaje"
    exit 1
fi


Tarjeta=$(lsblk | grep -m 1 -o $DISP)
Tarjetapart=$(lsblk | egrep -o "$DISP""p[0-9]")

if [[ ! -f $ISO ]]; then
	echo -e "El fichero de imagen no existe\n"
        exit 1
elif [[ ! -d $PTH ]]; then
	echo -e "El directorio de montaje no existe\n"
	exit 1
fi


contador=0
ip=0
particion="p2"

while ((contador < $NM))
do

    if [[ "$Tarjeta" = "$DISP" ]]; then
        ((contador++))
        echo -e "Se realizaran las siguientes operaciones:\n"
        
        for p in $Tarjetapart
        do
            echo -e "Desmontaje de $p\n"
        done       
        
        echo -e "Copia de la imagen $ISO en $DISP\n"
        echo -e "Se le otorgará el siguiente direccionamiento:\n 172.22.90.10$ip"
	
        echo -e "¿Continuar?"
        read confirmacion

        case "${confirmacion,,}" in
            
            "y") 
                 for x in $Tarjetapart
                 do
                     umount /dev/$x
                 done
	         
                 echo -e "Cargando imagen el dispositiov $DISP\n"
                 dd if=$ISO of=/dev/$DISP
                 sync

                 echo -e "Preparando claves ssh\n"
                 mount /dev/$DISP$particion $PTH
		 mkdir -p $PTH/root/.ssh/
                 cp ./authorized_keys $PTH/root/.ssh/ 
                 sync

                 echo -e "Preparando direccionamiento estático"
                 cp ./eth0.network $PTH/etc/systemd/network
		 sed -i "s/:/$ip/" $PTH/etc/systemd/network/eth0.network
                 chmod 644 $PTH/etc/systemd/network/eth0.network
                 sync
		 
		 echo "raspi-$ip" > $PTH/etc/hostname
		 ((ip++))
		 echo -e "Sincronizando y desmontando"
                 sync
                 umount /dev/$DISP$particion
                 sync

                 echo -e "Redimensionando partición 2\n"
                 parted /dev/$DISP resizepart 2 31000
                 sync                

                 echo -e "Comprobando sistema de ficheros\n"
                 e2fsck -f /dev/$DISP$particion
                 sync

                 echo -e "redimensionando sistema de ficheros"
                 resize2fs /dev/$DISP$particion
                 sync

                 echo -e "Presione cualquier tecla para continuar con el despliegue\n"
                 read continuar
	         ;;
	    
	    *) 
		 echo -e "Saliendo \n"
	         exit 1
	         ;;
        esac
    
    else
	    echo -e "El dispositivo no coincide... Saliendo\n"
	    exit 1
    fi
done

echo -e "Despliegue concluido\n Adiós"
exit 0
