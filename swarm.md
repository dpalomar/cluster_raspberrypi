---
layout: index
---

## ¿Qué es Docker Swarm?

Docker Swarm es la herramienta nativa que nos ofrece docker para construir cluster con docker, es decir, que un conjunto de nodos docker (donde se está ejecutando el docker engine y donde podemos correr contenedores) sean usados con un único nodo docker virtual. La ventaja de utilizar Docker Swarm es que usa la misma API que docker, por lo tanto, cualquier herramienta que se pueda comunicar con el demonio docker podrá usar swarm. En este caso herramientas como docker compose o docker cliente pueden usar, de la misma forma, un solo nodo docker, como un cluster swarm.

### ¿Cómo se crea un cluster con Docker Swarm?