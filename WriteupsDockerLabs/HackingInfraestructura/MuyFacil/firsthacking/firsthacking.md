<center><h1>FirstHacking From DockerLabs.es</h1></center>  
<p align="center">

<img src="img/banner.png" width="400">


## ❓ ¿De qué se trata Firsthacking?

Firsthacking es una máquina vulnerable en docker en categoria "Súper Fácil" de la web **[DockerLabs](https://dockerlabs.es/)**, en la cual podremos practicar Hacking a Infraestructura; exclusivamente explotación del **backdoor de vsftpd 2.3.4** para lograr la flag de acceso a root, según la descripción.

<img src="img/firsthacking.png" width="400">

> [!NOTE]
>
>Puede descargar la máquina a través del **[enlace mega](https://mega.nz/file/oCd2VC5D#QfiRoFmZrZ-FjTuyRX9bLw7638fjluwp6jNth7JjXTw)**


## 🔝 Despliegue Máquina FirstHacking

Al descargar la máquina, es necesario descomprimir.

**unzip firsthacking.zip.**

![unzip FirstHacking](img/unzip.png)

Obtendremos dos ficheros:
- **Auto_deploy.sh:** Script Bash para desplegar nuestra máquina localmente.
- **firsthacking.tar:** Máquina vulnerable contenizada.

Para desplegar el servicio será necesario permisos de ejecución a auto_deploy.sh, ya que por defecto tiene permisos 644. Para ello, usaremos el comando:

 **chmod +x auto_deploy.sh**
 
 ![Chmod auto_deploy](img/chmod.png)

 Una vez ejecutado, se utilizará el comando **./auto_deploy.sh firsthacking.tar** para lanzar la máquina vulnerable.

![Despliegue](img/despliegue.png)

## 🔎 Fase de Preparación
Abrimos una segunda ventana de terminal donde trabajaremos, ejecutando **./run-kali.sh normal**... (Proyecto propio de kali portable en el siguiente repo, **[Vortex_Source](https://github.com/V0rt3xS0urc3/RedTeam-Portfolio)**

![./run-kali.sh](img/RunKaliNormal.png)

En una nueva terminal comenzamos haciendo 3 ping a la ip que nos ha dado el contenedor,**(172.17.0.2)** y luego de detectar que está vivo, escaneamos con Nmap. 
En esta ocación, se usará el comando **nmap -sC -sV --min-rate 5000 172.17.0.2**

| Argumento | Significado |
|---|---|
| -sC | Ejecuta los scripts para comprobaciones comunes |
| -sV | Detección de versiones de servicios |
| --min-rate 5000 | Envía al  5000 paquetes por segundo (aumenta velocidad; puede causar pérdida o detección) |
| 172.17.0.2 | Dirección IP del objetivo a escanear |


![Ping y Escaneo](img/PingNmap.png)

> [!NOTE]
>
>Como estamos en un entorno controlado se usa modo agresivo. en entornnos reales será necesario utilizar el argumento **-sS** para no ser detectado por algun IDR, **no se usará --min-rate.**


Hemos encontrado 1 puerto abierto:
**FTP (Puerto: 21):** Puerto FTP vsftpd 2.3.4, la cual según la consigna es un backdoor.



## 🧪 Post-Laboratorio
Una vez finalizada la máquina, presionamos lacombinación de teclas **Control + C** para eliminarla, y exit a nuestra máquina kali portable.

![Cerrar laboratorio](img/CtrlC.png)
![salir kali portable](img/ExitKali.png)



[![LinkedIn](https://img.shields.io/badge/LinkedIn-diego_arriagada_zamora-0077B5?style=for-the-badge&logo=linkedin&logoColor=white&labelColor=101010)](https://www.linkedin.com/in/diegoarriagadazamora) [![Instagram](https://img.shields.io/badge/Instagram-@diego_arriagadadev-E4405F?style=for-the-badge&logo=instagram&logoColor=white&labelColor=101010)](https://instagram.com/diego_arriagadadev)
