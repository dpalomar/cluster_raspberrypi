---
layout: index
---

## Despliegue de la imagen de Arch linux ARM.

En este punto ya tenemos una imagen con el sistema operativo operativa, por lo que vamos a proceder a cargarla en una tarjeta SD para poder usarla con la Raspberry Pi.  
Esta tarea la realizaremos en 3 pasos:

* __Instalacion de paquetes necesarios__ 
* __Carga de la imagen__
* __Redimensionado de las particiones y sistemas de ficheros__

1. __Instalación del software necesario:__
   
   En este aprtado usaremos el paquete "parted" que contiene todas las herramientas necesarias para escribir la imagen
   en la tarjeta SD y redimensionar las particiones.  Podemos instalarlo con el siguiente comando:

        # apt-get update; apt-get install parted

2. __Carga de la imagen:__

   La carga de la imagen la realizaremos con la utilidad "dd" que nos proporciona Debian. Ejecutaremos la siguiente orden:

       # dd if=arch-image.img of=/dev/mmcblk0 bs=2M
         512+0 registros leídos
         512+0 registros escritos
         1073741824 bytes (1,1 GB) copiados, 255,00014 s, 4 MB/s

       # lsblk
         NAME       MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
         mmcblk0    254:16   0   32G  0 disk 
         ├─mmcblkp1 254:17   0  100M  0 part 
         └─mmcblkp2 254:18   0  923M  0 part

3. __Redimensionado de particion, sistema de ficheros y comprobación de consistencia:__

  Una vez cargada la imagen en la tarjeta SD procederemos a redimensionar la partición número 2 (/root) lo máximo posible con el objetivo de 
  aprovechar la capacidad de nuestra tarjeta SD. Para realizar esta tarea usaremos las herramientas "parted" y "resize2fs"

    # parted /dev/mmcblk0 resizepart 2
      End?  [1074MB]? 32GB
      Information: You may need to update /etc/fstab.

  Nuestra partición se encuentra ya redimensionada, ahora es el turno del sistema de ficheros.  
  Primero revisaremos el sistema de ficheros con "e2fsck -f", una vez revisado, procederemos a la redimension del mismo con "resize2fs":

    # e2fsck -f /dev/mmcblk0p2
      e2fsck 1.42.12 (29-Aug-2014)
      Paso 1: Verificando nodos-i, bloques y tamaños
      Paso 2: Verificando la estructura del directorio
      Paso 3: Revisando la conectividad de directorios
      Paso 4: Revisando las cuentas de referencia
      Paso 5: Revisando el resumen de información de grupos
      /dev/mmcblk0p2: 32166/59136 ficheros (0.4% no contiguos), 166867/236288 bloques

    # resize2fs /dev/mmcblk0p2
      resize2fs 1.42.12 (29-Aug-2014)
      Cambiando el tamaño del sistema de ficheros en /dev/mmcblk0p2 a 7786644 (4k) bloques.
      The filesystem on /dev/mmcblkp2 is now 7786644 (4k) blocks long.

  Cuando terminemos dichas operaciones podremso comprobar con lsblk que los tamaños de partición y de sistema de ficheros ha cambiado:
    
    # lsblk
      NAME       MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
      mmcblk0    254:16   0   32G  0 disk 
      ├─mmcblkp1 254:17   0  100M  0 part 
      └─mmcblkp2 254:18   0 29,7G  0 part

  asdasd 
