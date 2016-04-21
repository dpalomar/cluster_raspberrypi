---
layout: index
---

## Instalación del SO Raspbian en los dispositivos

En esta parte del proyecto realizaremos la instalación del sistema operativo Raspbian 8.0 "Jessie" en su versión "lite".  
El motivo de usar esta versión es debido a la ausencia de entorno gráfico, ya que nos es completamente imprescindible para nuestro propósito.


### Creación de un script de despliegue:

```bash
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
			echo -e "Debe introducir el dispositivo donde \
se encuentra la tarjeta SD\n el número de tarjetas SD y un directorio \
de montaje"
			exit 1
			;;
	esac
done


if [[ $OPTIND -eq 1 ]]; then
			
    echo -e "Debe introducir el dispositivo donde se encuentra la tarjeta SD\n \ 
, el número de tarjetas SD y un directorio de montaje"
    exit 1
fi

magic="*"
Tarjeta=$(lsblk | grep -m 1 -o $DISP)


echo "$Tarjetaf"

contador=0
ip=0
particion="p2"

while ((contador < $NM))
  do

    if [[ "$Tarjeta" = "$DISP" ]]; then
        ((contador++))       
        echo -e "Se procederá a escribir en $DISP. y/n?"
	read confirmacion

        case "${confirmacion,,}" in
            
            "y") 
                 umount /dev/$DISP$magic > /dev/null
	         dd if=$ISO of=/dev/$DISP bs=2M
                 mount /dev/$DISP$particion $PTH
                 cp ./interfaces $PTH/etc/network/interfaces 
		 sed -i "s/:/$ip/" $PTH/etc/network/interfaces
                 #rm -rf $PTH/etc/systemd/system/dhcpcd*
		 find $PTH/etc/systemd/system/ -iname "*dhcpcd*" -exec rm {} \;
		 ((ip++))
		 echo -e "Desmontando"
                 umount /dev/$DISP$magic > /dev/null
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
```
