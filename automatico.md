---
layout: index
---

## Despliegue automático de la imagen base en las distintas máquinas

En el apartado [Despliegue de la imagen base en las distintas máquinas](instalacion) hemos estudiado la forma manual para copiar nuestra imagen base en una raspberry Pi y como la hemos configurado posteriormente. Evidentemente si estamos trabajando con un cluster de máquinas el despliegue incial del sistema operativo puede ser una labor tediosa y muy lente, es por ello que hemos desarrollado un script en bash que nos facilita la tarea.

### Script bash para automatizar el despliegue

Es script que vamos a utilizar para la instalación automática en varias raspberry pi lo duedes descargar en el fichero [script-despliegue.sh](https://raw.githubusercontent.com/iesgn/cluster_raspberrypi/gh-pages/script/scipt-despliegue.sh). Veamos las funcionalidades que nos ofrece:

* La función principal del programa es copiar una imagen en una tarjeta SD, por lo tanto tendremos que indicar en el programa el dispositivo donde se encuentra la tarjeta SD y la imagen que queremos copiar.
* Podemos indicar el número de tarjetas SD que queremos copiar con la misma imagen. Actualmente sólo se puede indicar como máximo 9 dispositivos).
* Una vez copiada la imagen a la tarjeta SD se realiza una operación de redimencionado de la partición y el sistema de archivo a 32Gb (capacidad de nuestras tarjetas).
* En cada una de las imágenes que copie en las distintas tarjetas SD, configura el sistema operativo para que cada Raspberr Pi tenga un direccionamiento estático, además en cada copia va cambiando la dirección ip de cada dispositivo. (En nuestro caso hemos utilizado el segmento 172.22.90.0/16, empezando a asignar la dirección 172.22.90.100 al primer dispositivo).
* En cada una de las instalaciones se asigna un nombre del host distinto (clpi1, clpi2, ...)

#### Configuración del direccionamiento estático

Además del script tenemos que bajarnos el fichero [eth0.network](https://raw.githubusercontent.com/iesgn/cluster_raspberrypi/gh-pages/script/eth0.network), que es el fichero de configuración de red de Arch Linux:

      [Match]
      Name=eth0      

      [Network]
      Address=172.22.90.10:/16
      Gateway=172.22.0.1
      DNS=192.168.102.2

El script copiará este fichero a la tarjeta SD y modificará la dirección IP en cada una de las copias. Este fichero habrá que modificarlo según la configuración especifica de cada infraestructura.

#### Utilización del script de automatización

El script lo tenemos que ejecutar como root, y la sintaxis es la siguiente:

	# ./script-despliegue.sh \
	  -d mmcblk0 \         
	  -n 4 \
	  -m /mnt \
	  -i arch-image.img

Tenemos que indicar los siguientes parámetros:

* **-d**: Indicamos el dispositivo asociado a la tarjeta SD.
* **-n**: Indicamos el número de tarjetas que vamos a copiar.
* **-m**: Indicamos un directorio temporal donde se va a montar la imagen para copiar los archivos necesarrios y realizar las configuraciones.
* **-i**: Indicamos la imagen que vamos a copiar.

Recuerda que en el mismo directorio donde tengamos el script debemos tener el fichero de configuración de red (eth0.network).


