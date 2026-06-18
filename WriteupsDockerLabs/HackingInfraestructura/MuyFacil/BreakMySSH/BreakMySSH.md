<div align="center">

# BreakMySSH From DockerLabs.es

<img src="img/banner.png" width="600">

</div>

## ❓ ¿De qué se trata BreakMySSH?

*BreakMySSH es una máquina vulnerable en docker en categoria "Súper Fácil" de la web **[DockerLabs](https://dockerlabs.es/)**, en la cual podremos practicar Hacking a Infraestructura; exclusivamente **fuerza bruta con hydra contra protocolo SSH** para lograr la flag de acceso a root, según la descripción.*

<img src="img/BreakMySSH.png" width="400">

> [!NOTE]
>
>*Puede descargar la máquina a través del* **[enlace mega](https://mega.nz/file/hfE3lbwZ#ExAcF54AyOHeJqgH2R4cDIAGc5IVlJnI5Rs-Us2QMpM)**


## 🔝 Despliegue Máquina BreakMySSH

*Al descargar la máquina, es necesario descomprimir.*

**unzip breakmyssh.zip.**

<img src="img/unzip.png" width="400">

*Obtendremos dos ficheros:*
*- **Auto_deploy.sh:** Script Bash para desplegar nuestra máquina localmente.*
*- **breakmyssh.tar:** Máquina vulnerable contenizada.*

*Para desplegar el servicio será necesario permisos de ejecución a auto_deploy.sh, ya que por defecto tiene permisos 644. Para ello, usaremos el comando:*

 **chmod +x auto_deploy.sh**
 
 <img src="img/chmod.png" width="400">

 *Una vez ejecutado, se utilizará el comando **./auto_deploy.sh breakmyssh.tar** para lanzar la máquina vulnerable.*

<img src="img/despliegue.png" width="400">

## 🔎 Fase de Preparación
*Abrimos una segunda ventana de terminal donde trabajaremos, ejecutando* **./run-kali.sh normal**... *(Proyecto propio de kali portable en el siguiente repo,* **[Vortex_Source](https://github.com/V0rt3xS0urc3/RedTeam-Portfolio)**

<img src="img/RunKaliNormal.png" width="400">

*En una nueva terminal comenzamos haciendo 3 ping a la ip que nos ha dado el contenedor,* **(172.17.0.2)** *y luego de detectar que está vivo, escaneamos con Nmap.*
*En esta ocación, se usará el comando* **nmap -sC -sV --min-rate 2000 172.17.0.2** 

*| Argumento | Significado |*
*|---|---|*
*| -sC | Ejecuta los scripts para comprobaciones comunes |*
*| -sV | Detección de versiones de servicios |*
*| --min-rate 2000 | Envía 2000 paquetes por segundo (aumenta velocidad; puede causar pérdida o detección) |*
*| 172.17.0.2 | Dirección IP del objetivo a escanear |*


<img src="img/PingNmap.png" width="400">

> [!NOTA]
>
>*Como estamos en un entorno controlado se usa modo agresivo. en entornnos reales será necesario utilizar el argumento **-sS** para no ser detectado por algun IDR,* **no se usará --min-rate.**


*Hemos encontrado 1 puerto abierto:*
**SSH (Puerto: 21):** *Puerto SSH OpenSSH 9.2p1.*

<img src="img/PingNmap.png" width="400">

*Usaremos Hydra para encontrar el usuario y password de SSH* **hydra -L /usr/share/seclists/Usernames/top-usernames-shortlist.txt -P /usr/share/wordlists/rockyou.txt ssh://172.17.0.2 -t 4** *usando el top usernames de seclist y el diccionario rockyou, logramos encontrar el usuario: * **root** *con la password:* **estrella**.

<img src="img/hydra.png" width="400">



*Luego entramos a ssh con las credenciales encontradas* **ssh root@172.17.0.2** *y contraseña* **estrella**, hacemos pwd y luego whoami, y verifdicamos qyue ya estamos dentro como root.

<img src="img/root.png" width="400">


## 🧪 Post-Laboratorio
*Una vez finalizada la máquina, presionamos lacombinación de teclas* **Control + C** *para eliminarla!!!.*

<img src="img/CtrlC.png" width="400">


**Exit** *a nuestra máquina kali portable.*

<img src="img/ExitKali.png" width="400">

## 🔥 ¿Te gustó el WriteUp? Dale una estrella ⭐ en GitHub!

🔥 *¿Te gustó el WriteUp?*
*¡Dale una estrella ⭐ en* **![V0rt3x_S0urc3 ⭐](https://github.com/V0rt3xS0urc3/RedTeam-Portfolio/)!**

### 🎯 Pentester | Red Team | Hacker Ético

<div align="center">
<img src="img/Micaricatura.png" width="800">
</div>*


[![LinkedIn](https://img.shields.io/badge/LinkedIn-diego_arriagada_zamora-0077B5?style=for-the-badge&logo=linkedin&logoColor=white&labelColor=101010)](https://www.linkedin.com/in/diegoarriagadazamora) [![Instagram](https://img.shields.io/badge/Instagram-@diego_arriagadadev-E4405F?style=for-the-badge&logo=instagram&logoColor=white&labelColor=101010)](https://instagram.com/diego_arriagadadev)
