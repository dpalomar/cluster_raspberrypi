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

Vamos configurar nuestras Raspberry Pi con docker Engine desde el contrlador utilizando docker Machine, para ello ejecutamos la siguiente instrucción para instalar y configurar nuestra primera máquina:

    $ docker-machine create \
    --driver=generic \
    --generic-ssh-key="~/.ssh/id_rsa" \
    --generic-ip-address="172.22.90.100" \
    clpi1   

    Running pre-create checks...
    Creating machine...
    (clpi1) Importing SSH key...
    Waiting for machine to be running, this may take a few minutes...
    Detecting operating system of created instance...
    Waiting for SSH to be available...
    Detecting the provisioner...
    Provisioning with arch...
    Copying certs to the local machine directory...
    Copying certs to the remote machine...
    Setting Docker configuration on the remote daemon...
    Checking connection to Docker...
    Docker is up and running!
    To see how to connect your Docker Client to the Docker Engine running on this virtual machine, run: docker-machine env clpi1

Hemos indicado en los parámetros el tipo de driver: generic, la clave privada para acceder por ssh, la dirección IP de la máuina y su nombre. Haŕía que repetir el proceso para cada una de nuestras máquinas:

    $ docker-machine create --driver=generic --generic-ssh-key="~/.ssh/id_rsa" \
    --generic-ip-address="172.22.90.101" clpi2
    $ docker-machine create --driver=generic --generic-ssh-key="~/.ssh/id_rsa" \
    --generic-ip-address="172.22.90.102" clpi3   
    $ docker-machine create --driver=generic --generic-ssh-key="~/.ssh/id_rsa" \
    --generic-ip-address="172.22.90.103" clpi4

Finalmente podemos comprobar que las cuatro máquina estar gestionada por Docker Machine:

    $ docker-machine ls
    NAME    ACTIVE   DRIVER    STATE     URL                        SWARM   DOCKER    ERRORS
    clpi1   -        generic   Running   tcp://172.22.90.100:2376           v1.11.2   
    clpi2   -        generic   Running   tcp://172.22.90.101:2376           v1.11.2   
    clpi3   -        generic   Running   tcp://172.22.90.102:2376           v1.11.2   
    clpi4   -        generic   Running   tcp://172.22.90.103:2376           v1.11.2   

A continuación para conectarnos desde nuestro cliente docker al Docker Engine de cualquiera de nuestras máquinas necesitamos declarar las variables de entornos adecuadas, para obtener las variables de entorno la máuina clpi1 podemos ejecutar:

    $ docker-machine env clpi1
    export DOCKER_TLS_VERIFY="1"
    export DOCKER_HOST="tcp://172.22.90.100:2376"
    export DOCKER_CERT_PATH="/home/debian/.docker/machine/machines/clpi1"
    export DOCKER_MACHINE_NAME="clpi1"

Y para ejecutar estos comandos y que se creen las variables de entorno, ejecutamos:

    $ eval $(docker-machine env clpi1)

A partir de ahora, y utilizando el cliente docker, estaremos trabajando con el Docker Engine de clpi1:

    $ docker ps
    CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES

Evidentemente vemos que no tenemos ningún contenedor en clpi1.

Otras opciones de docker-machine que podemos utilizar son:

* inspect: Nos devuelve información de una máquina.
* ssh, scp: Nos permite acceder por ssh y copiar ficheros a una determinada máquina.
* start, stop, restart, status: Podemos controlar una máquina.
* rm: Es la opción que borra una máquina de la base de datos de Docker Machine. Con determinados drivers también elimina la máquina.
* upgrade: Actualiza a la última versión de docker la máquina indicada.

Por ejemplo para acceder a la máquina clpi2, podemos ejecutar:

    $ docker-machine ssh clpi2
    Welcome to Arch Linux ARM   

         Website: http://archlinuxarm.org
           Forum: http://archlinuxarm.org/forum
             IRC: #archlinux-arm on irc.Freenode.net
    Last login: Wed Jun  8 11:10:42 2016 from 172.22.206.15
    [root@clpi2 ~]# 

Una vez que tenemos nuestras máquinas del cluster preparadas, en la siguiente sección vamos a estudiar como instalar Docker Swarm.












