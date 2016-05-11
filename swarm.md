---
layout: index
---

## ¿Qué es Docker Swarm?

Docker Swarm es la herramienta nativa que nos ofrece docker para construir cluster con docker, es decir, que un conjunto de nodos docker (donde se está ejecutando el docker engine y donde podemos correr contenedores) sean usados con un único nodo docker virtual. La ventaja de utilizar Docker Swarm es que usa la misma API que docker, por lo tanto, cualquier herramienta que se pueda comunicar con el demonio docker podrá usar swarm. En este caso herramientas como docker compose o docker cliente pueden usar, de la misma forma, un solo nodo docker, como un cluster swarm.

### ¿Cómo se crea un cluster con Docker Swarm?

Para crear un cluster con Docker Swam necesitamos descargar la imagen docker de Docker Swarm. Con esta imagen podemos configurar el supervisor del cluster (manager) y todos los nodos que formaran el cluster (agents). Este proceso conlleva los siguientes aspectos:

* Tenemos que abrir un puerto TCP para que todos los nodos se comuniquen con el Swarm manager.
* Tenemos que instalar docker en todos los nodos.
* Todas las conexiones entre los distintos nodos deben ser seguras utilizando certificados TLS.

### Métodos para la creación de un cluster con Docker swarm

Tenemos dos formas de crear nuestro cluster:

* El método manual, es decir realizamos todas las instalaciones y configuraciones (instalación de docker en todos los nodos, configuración de la comunicación segura con los certificados TLS, descarga de la imagen docker de swarm, creación y configuración de los contenedores swarm manager y de los sawarms agents,...). Esté método sería muy adecuado para configuraciones avanzadas donde el administrador de sistemas quiere controlar todo el proceso.
* Utilizando docker-machine, que es una herramienta que nos facilita la gestión de nodos docker. Este mecanismo es el más apropiado para tener un primer contacto con la creación de cluster con docker swarm.

### Creación de un cluster Docker Swarm con docker-machine

docker-machine es una herramienta que nos ayuda a crear, configurar y manejar máquinas (virtuales o físicas) con docker engine. Con docker-engine podemos iniciar, parar o reiniciar los nodos docker, actualizar el cliente o el demonio docker y configurar el cliente docker para acceder a los distintos docker engine.

docker-machine utiliza distintos drivers que nos permite crear y configurar docker engine en distintos entornos y proveedores, por ejemplo virtualbox, AWS, VMWare, ... 

También podemos utilizar un driver genérico que nos permite manejar máquinas que ya están creadas (físicas o virtuales) y configurarlas por SSH. Al utilizar este driver se ejecutarán las siguientes tareas:

* Si la máuina no tiene insitala docker, lo instalará y lo configurará.
* Actualiza todos los paquetes de la máquina.
* Genera los certificados TLS para la comunicación segura.
* Reiniciará el docker engine, por lo tanto si tuviéramos contenedores, estos serán detenidos.
* Se cambia el nombre de la máquina para que coincida con el que le hemos dado con docker-machine.

En la próxima sesión explicaremos la creación de un cluster de raspberrypi con Docker Sawrm utilizando docker-machine.