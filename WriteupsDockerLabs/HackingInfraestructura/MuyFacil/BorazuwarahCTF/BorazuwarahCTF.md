<div align="center">

# BorazuwaraCTF From DockerLabs.es

<img src="img/banner.png" width="600">

</div>

## ❓ ¿De qué se trata BorazuwarahCTF?

BorazuwarahCTF es una máquina vulnerable de DockerLabs en la categoría "Súper Fácil", diseñada para practicar **esteganografía** y **fuerza bruta contra protocolos de red**. El objetivo es obtener acceso como root mediante técnicas de extracción de información oculta en imágenes y ataques de diccionario a SSH.

**Dificultad:** Súper Fácil  
**Categoría:** Hacking Infraestructura  
**Sistema Operativo:** Linux  
**Técnicas principales:** Esteganografía, Fuerza Bruta SSH, Escalada con Sudo

<img src="img/BorazuwarahCTF.png" width="400">

> [!NOTE]
>
>*Puede descargar la máquina a través del* **[enlace mega](https://mega.nz/file/gWNQlaZD#CgYMb_EEBL0jcypTg0xZZUaIqhO47ueX6pPU6utLy1U)**


## 🚀 Despliegue de la Máquina

### Descarga y Preparación

Al descargar la máquina desde DockerLabs, obtenemos un archivo comprimido que contiene:
- `auto_deploy.sh`: Script de despliegue automático
- `borazuwarahctf.tar`: Imagen del contenedor Docker

### Instalación

# Descomprimir el archivo
unzip borazuwarahCTF.zip

<img src="img/unzip.png" width="400">

# Dar permisos de ejecución al script
chmod +x auto_deploy.sh

 <img src="img/chmod.png" width="400">
 
 
# Ejecutar el despliegue automático
./auto_deploy.sh borazuwarahctf.tar

<img src="img/despliegue.png" width="400">

## 🔎 Fase de Preparación
*Abrimos una segunda ventana de terminal donde trabajaremos, ejecutando* **./run-kali.sh normal**... *(Proyecto propio de kali portable en el siguiente repo,* **[Vortex_Source](https://github.com/V0rt3xS0urc3/RedTeam-Portfolio)**

<img src="img/RunKaliNormal.png" width="400">


*🔎 Fase de Reconocimiento*
*Verificación de Conectividad*
*Primero verificamos que la máquina está activa:*

*En una nueva terminal comenzamos haciendo 3 ping a la ip que nos ha dado el contenedor,* **(172.17.0.2)** *y luego de detectar que está vivo, escaneamos con Nmap.*
*En esta ocación, se usará el comando* **nmap -sC -sV --min-rate 2000 172.17.0.2** 

*| Argumento | Significado |*
*|---|---|*
*| -sC | Ejecuta los scripts para comprobaciones comunes |*
*| -sV | Detección de versiones de servicios |*
*| --min-rate 2000 | Envía 2000 paquetes por segundo (aumenta velocidad; puede causar pérdida o detección) |*
*| 172.17.0.2 | Dirección IP del objetivo a escanear |*


<img src="img/PingNmap.png" width="400">

    *⚠️ Nota sobre Entorno Controlado vs Real:*
    *En este laboratorio usamos --min-rate 2000 para acelerar el escaneo. En un pentest real, este enfoque agresivo podría:*

        Ser detectado por sistemas IDS/IPS
        Saturar la red objetivo
        Bloquear tu IP automáticamente

    *En producción, usaríamos -sS (SYN scan) y tasas más conservadoras para evitar detección.*


*Servicios encontrados:*
**SSH (Puerto: 22):** *Puerto SSH OpenSSH 9.2p1.*
**HTTP (Puerto: 80):** *Puerto HTTP.*

<img src="img/PingNmap.png" width="400">

*🌐 Fase de Enumeración Web*

*Inspección del Sitio Web*
*Accedemos a http://172.17.0.2 y encontramos una página con una imagen de un Huevo Kinder Sorpresa.*

<img src="img/inspector.png" width="400">

*Descarga de la Imagen*
*Usamos el inspector del navegador para identificar el nombre del archivo y lo descargamos:*

<img src="img/wget.png" width="400">

*Búsqueda de Directorios con Gobuster*

*Antes de analizar la imagen, buscamos archivos ocultos en el servidor web:* **gobuster dir -u http://172.17.0.2 -w /usr/share/wordlists/dirb/common.txt -x jpeg,jpg,png,php,txt,html,doc**

*Resultado: No se encontraron archivos adicionales relevantes.*

<img src="img/gobuster.png" width="400">

*🔍 Fase de Esteganografía*

*Análisis con Stegseek*
*Ejecutamos stegseek para buscar datos ocultos en la imagen:* **stegseek huevito.jpeg /usr/share/wordlists/rockyou.txt**

*Resultado:*

<img src="img/stegseek.png" width="400">

*Extracción del Contenido*


<img src="img/steghide.png" width="400">

*Contenido: El archivo extraído contiene texto que no revela información útil directamente.*

<img src="img/secreto.png" width="400">

*Análisis de Metadatos con Exiftool*

*Revisamos los metadatos de la imagen en busca de información oculta:* **exiftool huevito.jpeg**

*Resultado:* *Hallazgo clave: Encontramos el nombre de usuario borazuwarah en los metadatos de la imagen.*

<img src="img/exiftool.png" width="400">

*🔓 Fase de Explotación*

*Ataque de Fuerza Bruta con Hydra*
*Con el usuario identificado, procedemos a atacar SSH con Hydra:* **hydra -l borazuwarah -P /usr/share/wordlists/rockyou.txt ssh://172.17.0.2 -t 64**

*Resultado:*

<img src="img/hydrabora.png" width="400">

*Credenciales obtenidas:*

    *Usuario: borazuwarah*
    *Contraseña: 123456*

*Comparación:
Hydra vs Nmap ssh-brute*
*Como experimento, también probamos el script de Nmap para fuerza bruta:* 

# Crear archivo con el usuario
**echo -e "borazuwarah" > usuarios.txt**

# Ejecutar ataque con Nmap
**nmap -p 22 --script ssh-brute --script-args userdb=usuarios.txt,passdb=top1000.txt 172.17.0.2**

*Análisis: En este entorno de red local (Docker), Nmap fue más rápido debido a su gestión más eficiente de conexiones TCP. Sin embargo, en redes reales con latencia, Hydra suele ser más confiable.*

*Acceso SSH*

*Con las credenciales válidas, nos conectamos:* **ssh borazuwarah@172.17.0.2**

*🔐 Escalada de Privilegios*

*Enumeración de Permisos Sudo*
*Una vez dentro, verificamos qué comandos podemos ejecutar como root:* **sudo -l**

*Resultado:User borazuwarah may run the following commands on borazuwarahctf:*
    **(ALL) /bin/bash**
    
*Análisis: El usuario puede ejecutar bash como root sin restricciones. Esto es una configuración extremadamente peligrosa.*
*Explotación*

*Ejecutamos bash con privilegios de root:* **sudo bash**
*Verificamos que ahora somos root:* **whoami root**,**id uid=0(root) gid=0(root) grupos=0(root)**


*🏁 Captura de Flag*

*Accedemos al directorio root y capturamos la flag:*

<img src="img/root.png" width="400">

*📚 Aprendizajes Clave*

*Técnicas Aprendidas*

    *Esteganografía:*
        Uso de stegseek para detectar y extraer datos ocultos en imágenes
        Análisis de metadatos con exiftool para encontrar información oculta
        
    *Fuerza Bruta SSH:*
        Uso de Hydra para ataques de diccionario
        Comparación con Nmap ssh-brute
        Optimización de hilos para evitar bloqueos
        
    *Escalada con Sudo:*
        Identificación de permisos peligrosos con sudo -l
        Explotación de bash con privilegios de root
        
    *Enumeración Web:*
        Uso de Gobuster para descubrir archivos ocultos
        Inspección de código fuente para encontrar recursos

*Reflexiones Profesionales*

*⚠️ Lecciones de Seguridad:*

*Esta máquina demuestra múltiples fallos de seguridad comunes:*

    *Esteganografía como vector de ataque:*
        Los metadatos de imágenes pueden revelar información sensible
        Nunca expongas credenciales en comentarios o metadatos
        
    *Contraseñas débiles:*
        "123456" está en los primeros puestos de rockyou.txt
        Implementa políticas de contraseñas fuertes
        
    *Configuración peligrosa de sudo:*
        Permitir ejecutar bash como root es equivalente a dar acceso root completo
        Usa sudo con comandos específicos, no shells interactivas
        
    *SSH expuesto:*
        Implementa fail2ban para bloquear ataques de fuerza bruta
        Usa autenticación por claves en lugar de contraseñas
        Cambia el puerto por defecto (aunque esto es seguridad por oscuridad)


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
