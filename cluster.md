---
layout: index
---

## Esquema de nuestro cluster

![docker](img/docker-machine.jpg)

Para comenzar a construir nuestro cluster, partimos de que tenemos instaladas y configuradas nuestras Raspberry Pi con el sistema operativo. Hemos vistos dos opciones para conseguir este objetivo:

* [Despliegue de la imagen base en las distintas máquinas](instalacion)
* [Despliegue automático de la imagen base en las distintas máquinas](automatico)

Nuestra infraestrutura va a estar formada por 5 equipos:

* El **controlador**, puede ser cualquier ordenador, en nuestro caso vamos a utilizar un equipo con Debian 8.0. En este equipo vamos a instalar el cliente docker para interactuar con los [Docker Engine](docker_engine) de cada una de las raspberry pi. En este equipo vamos a controlar las cuatro pi con la herramienta [Docker Machine](docker_machine), que nos va a permitir instalar docker engine en cada una de ellas y gestionarlas.
* Las cuatro **Raspberry Pi**, donde vamos a instalar Docker Engine por medio de la herramienta Docker Engine, que no va a permitir tambiaén gestionar estas máquinas.

