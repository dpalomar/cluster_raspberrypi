---
layout: index
---

## Creación de una imagen base de Arch Linux ARM para Raspberry Pi.

El primer paso para crear nuestro cluster es instalar un sistema operativo en nuetsras taspberry pi. En nuestro caso hemos elegido finalmente Arch Linux en su versión ARM.  El motivo de nuestra elección es que Arch Linux contiene Docker Engine en sus repositorios oficiales, lo que nos facilita la tarea inicialmente.  Tambien podemos incluir entre las ventajas (con algún inconveniente) su carácter Rolling Release, con lo cual podremos obtener facilmente las ultimas versiones del software que usaremos. En el caso de Docker es una gran ventaja, ya que es un software en constante evolución. Si nos decidimos a escoger otra distribución GNU/Linux, como por ejemplo, Debian, tendríamos que utilizar repositorios no oficiales o compilar los programas que necesitamos.


### Preparación del sistema para la creación de la imagen.

Todas las operaciones que vamos a realizar en este proyecto se van a realizar desde un ordenador donde tenemos instalado la distribución Debian 8.0 "Jessie", exceptuando aquellas que afecten directamente a los dispositivos Raspberry.

__Instalación de los paquetes necesarios__:

En primer lugar vamos a configurar Debian de manera adecuada para poder preparar  la imagen de Arch Linux. Vamos a necesitar tres paquetes:
  
* __curl:__ Para bajar la imagen en cli (opcional)
* __bsdtar:__ Este paquete lo usaremos para descomprimir el fichero con el SO. Es el recomendado por Arch Linux en su guía oficial para descomprimir conservando las propiedades de los ficheros.
* __kpartx:__ Lo usaremos para mapear las particiones que contiene la imagen de Arch Linux una vez creada.

Instalamos los paquetes con:

```bash
# apt-get update; apt-get install curl bsdtar kpartx
```

1. Descarga de la última version de Arch Linux para nuestras Raspberry Pis: 

   Aunque la Raspberry Pi 3 tiene una arquitectura ARM a 64 bits Cortex A-54, aún no se han desarrollado versiones del SO para dicha arquitectura, por lo que usaremos la versión de 32 bits disponible para la Raspberry Pi 2, que es completamente compatible:

   Podemos descargar la imagen con curl con el siguiente comando:

   
         # curl 'http://nl2.mirror.archlinuxarm.org/os/ArchLinuxARM-rpi-2-latest.tar.gz' \
           > -o 'ArchLinuxARM-rpi-2-latest.tar.gz'
             % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                            Dload  Upload   Total   Spent    Left  Speed
           100  281M  100  281M    0     0  1183k      0  0:04:03  0:04:03 --:--:-- 1222k
   

   En estos momentos tenemos en nuestro poder un fichero comprimido que contiene el sistema operativo. El siguiente paso es crear un fichero que convertiremos en un dispositivo de bloques, en el cual volcaremos la informacion del tar.gz

2. Creación del fichero de bloques con dd (duplicate disk)

         # dd if=/dev/zero of=arch-image.img bs=1M count=1024
           1024+0 registros leídos
           1024+0 registros escritos
           1073741824 bytes (1,1 GB) copiados, 1,06868 s, 1,0 GB/s
      
      Con esto ya tendríamos nuestro fichero de 1,1 GB creado (he cometido un pequeño error de cálculo, realmente el count debería ser de 1000 registros para obtener un gigabyte)

3. Asignamos lógicamente el fichero como un dispositivo de bloques "loop". 

   Para ello ejecutamos:

   
         # losetup -f arch-image.img
   
      La opción -f buscará el primer dispositivo loop disponible y cargará el fichero arch-image en dicho dispositivo, podemos comprobarlo con el comando "losetup -a":
   
         # losetup -a
            /dev/loop0: [65025]:537381029 (/arch-image.img)
      

   * El tercer paso es particionar el fichero mediante su asignación lógica (/dev/loop0), utilizaré para ello fdisk que es la utilidad que viene por defecto en el sistema.  
      Es muy importante que la partición de arranque esté etiquetada como "W95 FAT32 (LBA)", la otra puede quedarse como tipo "Linux".
      
      ```bash
      # fdisk /dev/loop0
      
      Bienvenido a fdisk (util-linux 2.25.2).
      Los cambios solo permanecerán en la memoria, hasta que decida escribirlos.
      Tenga cuidado antes de utilizar la orden de escritura.
      
      El dispositivo no contiene una tabla de particiones reconocida.
      Created a new DOS disklabel with disk identifier 0x5a250c16.
      ```
      Creamos una nueva partición 1 de tipo 'Linux' y de tamaño 100 MiB:

      ```bash
      Orden (m para obtener ayuda): n
      Tipo de partición
         p   primaria (0 primarias, 0 extendidas, 4 libres)
         e   extendida (contenedor para particiones lógicas)
      Seleccionar (valor predeterminado p): p
      Número de partición (1-4, valor predeterminado 1): 1
      Primer sector (2048-2097151, valor predeterminado 2048): 2048
      Último sector, +sectores o +tamaño{K,M,G,T,P} (2048-2097151, valor predeterminado 2097151): +100M
           
      
      Orden (m para obtener ayuda): t
      Se ha seleccionado la partición 1
      Código hexadecimal (escriba L para ver todos los códigos): c
      Si ha creado o modificado alguna partición DOS 6.x, consulte la documentación de fdisk para obtener más información.
      Se ha cambiado el tipo de la partición 'Linux' a 'W95 FAT32 (LBA)'.
      ```
      Creamos una nueva partición 2 de tipo 'Linux' y de tamaño 923 MiB.

      ```bash
      Orden (m para obtener ayuda): n
      Tipo de partición
         p   primaria (1 primarias, 0 extendidas, 3 libres)
         e   extendida (contenedor para particiones lógicas)
      Seleccionar (valor predeterminado p): p
      Número de partición (2-4, valor predeterminado 2): 2
      Primer sector (206848-2097151, valor predeterminado 206848): 206848
      Último sector, +sectores o +tamaño{K,M,G,T,P} (206848-2097151, valor predeterminado 2097151): 2097151
      
            
      Orden (m para obtener ayuda): w
      Se ha modificado la tabla de particiones.
      ```
      
      Ahora tenemos nuestro fichero arch-image.img particionado, para terminar, mapearemos dichas particiones con kpartx:
     
      ```bash
      # kpartx -a /dev/loop0
      ```
      Si ejecutamos "lsblk" veremos como ya aparecen las 2 nuevas particiones en el sistema:
     
      ```bash
      # lsblk /dev/loop0
      NAME      MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
      loop0       7:0    0    1G  0 loop 
      ├─loop0p1 254:2    0  100M  0 part 
      └─loop0p2 254:3    0  923M  0 part
      ``` 

   * Cuarto paso, crear los sistemas de ficheros:

      Este paso es muy importante, puesto que los dispositivos Raspberry Pi necesitan un sistema de ficheros FAT 32 para arrancar, así que ejecutaremos los siguientes comandos:

      Para crear el sisteme de ficheros en la partición "/dev/mapper/loop0p1" (100M /boot):
      
      ```bash
      # mkfs.vfat /dev/mapper/loop0p1
      mkfs.fat 3.0.27 (2014-11-12)
      unable to get drive geometry, using default 255/63
      ```
      
      Para crear el sisteme de ficheros en la partición  "/dev/mapper/loop0p2 (923M raiz)":
      
      ```bash
      # mkfs.ext4 /dev/mapper/loop0p2
      mke2fs 1.42.12 (29-Aug-2014)
      Descartando los bloques del dispositivo: hecho                           
      Se está creando El sistema de ficheros con 236288 4k bloques y 59136 nodos-i
      
      UUID del sistema de ficheros: d882f713-021c-4ab8-82e9-820f0b8749a2
      Respaldo del superbloque guardado en los bloques: 
      	32768, 98304, 163840, 229376
      
      Reservando las tablas de grupo: hecho                           
      Escribiendo las tablas de nodos-i: hecho                           
      Creando el fichero de transacciones (4096 bloques): hecho
      Escribiendo superbloques y la información contable del sistema de ficheros: hecho
      ```

   * Quinto paso, montaje de los sistemas de ficheros:
    
      Ya casi hemos terminado la creación de la imagen base. En estos momentos crearemos dos directorios donde montaremos los dos sistemas de ficheros que acabamos de crear. Vamos a montar en los directorios "boot" y "root" en el directorio "/mnt" de nuestro sistema:

      ```bash
      # mkdir /mnt/boot /mnt/root
      ```
      
      ```bash
      # mount /dev/mapper/loop0p1 /mnt/boot/
      # mount /dev/mapper/loop0p2 /mnt/root/
      ```
      Comprobacion del montaje:

      ```bash
      # df -h
      S.ficheros          Tamaño Usados  Disp Uso% Montado en
      /dev/mapper/loop0p1   100M      0  100M   0% /mnt/boot
      /dev/mapper/loop0p2   893M   1,2M  830M   1% /mnt/root
      ```

   * Sexto paso, carga del sistema operativo en el fichero de imagen:

      El sexto es el último paso de la creación de la imagen. En este paso descomprimiremos el archivo "ArchLinuxARM-rpi-2-latest.tar.gz" en nuestro fichero de bloques "arch-image.img".

      La comunidad de Arch Linux ARM recomienda usar bsdtar para la descompresión del fichero, ejecutaremos la siguiente orden:

      ```bash
      # bsdtar -xpf ArchLinuxARM-rpi-2-latest.tar.gz -C /mnt/root/
      ```
      Una vez finalizada la descompresión, tendremos que mover el contenido del directorio "/mnt/root/boot" a "/mnt/boot"

      ```bash
      # mv /mnt/root/boot/* /mnt/boot/
      ```

      Sincronizamos los dispositivos de bloques para asegurarnos su correcta escritura y desmontamos todo:

      ```bash
      # sync
      # umount /dev/mapper/loop0p{1,2}
      # losetup -d /dev/loop0
      # rmdir /mnt/root /mnt/boot
      ```


Una vez finalizado el sexto paso obtendremos una imagen base de Arch Linux lista para cargar en nuestras Raspberry Pis.  
Podremos ver como hacerlo en el siguiente apartado de nuestro proyecto:  
[Despliegue de la imagen base en las distintas máquinas](instalacion)
