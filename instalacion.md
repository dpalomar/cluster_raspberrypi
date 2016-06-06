---
layout: index
---

## Instalación del SO en las Raspberry Pi.

El primer paso para crear nuestro cluster es instalarles un sistema operativo. En nuestro caso hemos elegido finalmente Arch Linux en su versión ARM.  El motivo de nuestra elección es que Arch Linux contiene Docker-Engine en sus repositorios oficiales, loq ue nos facilita la tarea inicialmente.  Tambien podemos incluir entre las ventajas (con algún inconveniente) su carácter Rolling Release, con lo cual podremos obtener facilmente las ultimas versiones del software que usaremos. Esto es una ventaja en el caso de Docker, ya que es un software en constante evolución.


### Preparación del sistema para el despliegue.

Todas las operaciones que vamos a realizar en este proyecto se van a realizar desde Debian 8.0 "Jessie", exceptuando aquellas que afecten directamente a los dispositivos Raspberry.


1. Instalación de los paquetes necesarios:

El primer paso que vamos a realizar en preparar Debian para poder preparar la imagen de Arch Linux. Vamos a necesitar 3 paquetes:
    
* curl: Para bajar la imagen en cli (opcional)
* bsdtar: Este paquete lo usaremos para descomprimir el fichero con el SO. Es el recomendado por Arch Linux en su guía oficial para descomprimir conservando las propiedades de los ficheros.
Instalamos los paquetes con:
* kpartx: Lo usaremos para mapear las particiones que contiene la imagen de Arch Linux una vez creada.

```
# apt-get update; apt-get install curl bsdtar kpartx
```

2. Descarga de la ultima version de Arch Linux para nuestras Raspberris: 

Aunque la Raspberry Pi 3 tiene una arquitectura ARM a 64 bits Cortex A-54, aún no se han desarrollado versiones del SO para dicha arquitectura, por lo que usaremos la version de 32 bits disponible para la Raspberry Pi 2, que es completamente compatible:

Podemos descargar la imagen desde "http://nl2.mirror.archlinuxarm.org/os/ArchLinuxARM-rpi-2-latest.tar.gz" con curl con el siguiente comando:

```
# curl 'http://nl2.mirror.archlinuxarm.org/os/ArchLinuxARM-rpi-2-latest.tar.gz' \
  > -o 'ArchLinuxARM-rpi-2-latest.tar.gz'
    % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                   Dload  Upload   Total   Spent    Left  Speed
  100  281M  100  281M    0     0  1183k      0  0:04:03  0:04:03 --:--:-- 1222k
```

En estos momentos tenemos en nuestro poder un fichero comprimido que contiene el sistema operativo.  El siguiente paso es crear un fichero que convertiremos en un dispositivo de bloques, en el cual volcaremos la informacion del tar.gz


3. Creación del fichero de bloques:

Como comentabamos anteriormente, vamos a crear un fichero que usaremos como dispositivo de bloques, en el cual volcaremos los datos del fichero descargado anteriormente.
Esta en los siguientes pasos:

* El primer paso será crear el fichero con dd (duplicate disk)

  ```
  # dd if=/dev/zero of=arch-image.img bs=1M count=1024
    1024+0 registros leídos
    1024+0 registros escritos
    1073741824 bytes (1,1 GB) copiados, 1,06868 s, 1,0 GB/s
   ```
  Con esto ya tendríamos nuestro fichero de 1,1 GB creado (he cometido un pequeño error de cálculo, realmente el count debería ser de 1000 registros para obtener un gigabyte)

* El segundo paso es asignar lógicamente el fichero como un dispositivo de bloques "loop". Podemos conseguir este objetivo con losetup:

  ```
  # losetup -f arch-image.img
  ```
  La opción -f buscará el primer dispositivo loop disponible y cargará el fichero arch-image en dicho dispositivo, podemos comprobarlo con el comando "losetup -a"

  ```
   # losetup -a
     /dev/loop0: [65025]:537381029 (/arch-image.img)
  ```




* El tercer paso es particionar el fichero mediante su asignación lógica (/dev/loop0), utilizaré para ello fdisk que es la utilidad que viene por defecto en el sistema:

  ```
  # fdisk /dev/loop0

    Bienvenido a fdisk (util-linux 2.25.2).
    Los cambios solo permanecerán en la memoria, hasta que decida escribirlos.
    Tenga cuidado antes de utilizar la orden de escritura.
    
    El dispositivo no contiene una tabla de particiones reconocida.
    Created a new DOS disklabel with disk identifier 0x5a250c16.
    
    Orden (m para obtener ayuda): n
    Tipo de partición
       p   primaria (0 primarias, 0 extendidas, 4 libres)
       e   extendida (contenedor para particiones lógicas)
    Seleccionar (valor predeterminado p): p
    Número de partición (1-4, valor predeterminado 1): 1
    Primer sector (2048-2097151, valor predeterminado 2048): 2048
    Último sector, +sectores o +tamaño{K,M,G,T,P} (2048-2097151, valor predeterminado 2097151): +100M
    
    Crea una nueva partición 1 de tipo 'Linux' y de tamaño 100 MiB.
    
    Orden (m para obtener ayuda): t
    Se ha seleccionado la partición 1
    Código hexadecimal (escriba L para ver todos los códigos): c
    Si ha creado o modificado alguna partición DOS 6.x, consulte la documentación de fdisk para obtener más información.
    Se ha cambiado el tipo de la partición 'Linux' a 'W95 FAT32 (LBA)'.
    
    Orden (m para obtener ayuda): n
    Tipo de partición
       p   primaria (1 primarias, 0 extendidas, 3 libres)
       e   extendida (contenedor para particiones lógicas)
    Seleccionar (valor predeterminado p): p
    Número de partición (2-4, valor predeterminado 2): 2
    Primer sector (206848-2097151, valor predeterminado 206848): 206848
    Último sector, +sectores o +tamaño{K,M,G,T,P} (206848-2097151, valor predeterminado 2097151): 2097151
    
    Crea una nueva partición 2 de tipo 'Linux' y de tamaño 923 MiB.
    
    Orden (m para obtener ayuda): w
    Se ha modificado la tabla de particiones.
  ```



### Creación de un script de despliegue:



* parted (En una r): Lo usaremos para averiguar el offset de las particiones de la imagen que creamos y montarlas. Debido a que la arquitectura ARM no dispone del paquete "multipath-tools" no podremos usar kpartx para mapear las particiones de la imagen.

