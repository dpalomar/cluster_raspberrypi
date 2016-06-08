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

    $ docker-machine create --driver=generic --generic-ssh-key="~/.ssh/id_rsa" --generic-ip-address="172.22.90.100" clpi1   

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

    $ docker-machine create --driver=generic --generic-ssh-key="~/.ssh/id_rsa" --generic-ip-address="172.22.90.101" clpi2

    $ docker-machine create --driver=generic --generic-ssh-key="~/.ssh/id_rsa" --generic-ip-address="172.22.90.102" clpi3   

    $ docker-machine create --driver=generic --generic-ssh-key="~/.ssh/id_rsa" --generic-ip-address="172.22.90.103" clpi4

    






