---
layout: index
---

## Introducción

En esta página web vamos a documentar los procesos que vayamos realizando en la construcción y configuración de un cluster de raspberry pi, que vamos a realizar como proyecto un grupo de alumnos y profesores del [Departamento de Informática](http://informatica.gonzalonazareno.org) del IES Gonzalo Nazareno [(@dit_gn)](https://twitter.com/dit_GN).

![Comenzamos...](img/01.jpg)

## Índice

* Introducción
* [Montaje físico del cluster](hardware)
* Configuración inicial del sistema operativo
  * [Creación de una imagen base de Arch Linux ARM](imagen_base)
  * Imagen base para despliegue rápido con Ansible
  * Despliegue de la imagen base en las distintas máquinas
    * [Manual](instalacion)
    * [Automatizada](script)

* Instalación de Software
  * Docker Engine
  * Docker Swarm
  * Docker Machine
  * Automatización
    * Ansible

* Proyecto 1: Cluster de contenedores docker con docker swarm
	* [¿Qué es docker swarm?](swarm)
	* Creación de un cluster Docker Swarm con docker-machine
* Proyecto 2: Cluster de contenedores docker con Kubernete

## Enlaces interesantes

* [Docker Pirates ARMed with explosive stuff](http://blog.hypriot.com/)
* [How to setup a Docker Swarm cluster with Raspberry Pi's](http://blog.hypriot.com/post/how-to-setup-rpi-docker-swarm/)
* [Kubernetes on ARM project](https://github.com/luxas/kubernetes-on-arm)
* [Raspberry Pi Dramble](http://www.pidramble.com/)
* [Docker Networking and DNS: The Good, The Bad, And The Ugly](https://technologyconversations.com/2016/04/25/docker-networking-and-dns-the-good-the-bad-and-the-ugly/)
