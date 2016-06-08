---
layout: index
---

## Docker Machine

Docker Machine es una herramienta que nos ayuda a crear, configurar y manejar máquinas (virtuales o físicas) con Docker Engine. Con Docker Machine podemos iniciar, parar o reiniciar los nodos docker, actualizar el cliente o el demonio docker y configurar el cliente docker para acceder a los distintos Docker Engine. El propósito principal del uso de esta herramienta es la de crear máquinas con Docker Engine en sistemas remotos y centralizar su gestión.

Docker Machine utiliza distintos drivers que nos permiten crear y configurar Docker Engine en distintos entornos y proveedores, por ejemplo virtualbox, AWS, VMWare, OpenStack,... 

Nosotros vamos a utilizar un driver genérico (generic) que nos permite manejar máquinas que ya están creadas (nuestras raspberrys Pi) y configurarlas por SSH. Al utilizar este drive se ejecutarán las siguientes tareas:

* Si la máquina no tiene instalado docker, lo instalará y lo configurará.
* Actualiza todos los paquetes de la máquina.
* Genera los certificados TLS para la comunicación segura.
* Reiniciará el Docker Engine, por lo tanto si tuviéramos contenedores, estos serán detenidos.
* Se cambia el nombre de la máquina para que coincida con el que le hemos dado con Docker Machine.

### Instalación de Docker Machine en el controlador

Como hemos indicado anteriormente vamos a intalar Docker Machine en nuestro controlador para poder configurar los equipos de nuestro cluster. 

Para instalar la última versión (0.7.0) de esta herramienta ejecutamos:

    $ curl -L https://github.com/docker/machine/releases/download/v0.7.0/docker-machine-`uname -s`-`uname -m` > /usr/local/bin/docker-machine && \
    chmod +x /usr/local/bin/docker-machine

Y comprobamos la instalación:

    $ docker-machine -version
    docker-machine version 0.7.0, build a650a40

### Configuración de nuestras Raspberrys Pi con Docker Machine



