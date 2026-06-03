# 🔐 Kali Portable Full - Entorno de Pentesting en Docker

> **Autor:** Diego Arriagada Zamora  
> **GitHub:** [V0rt3x_S0urc3](https://github.com/V0rt3xS0urc3)  
> **LinkedIn:** [Diego Arriagada](https://linkedin.com/in/diegoarriagadazamora)  
> **Versión:** 1.0  
> **Tamaño de imagen:** ~8.57 GB  

---
## 📥 Descarga Rápida (Imagen Precompilada)

Si prefieres no construir la imagen desde el Dockerfile, descarga la versión precompilada (~8GB):

### Opción A: GitHub Release (Recomendado)

# Descargar todas las partes desde:
https://github.com/diegoarriagadazamora/redteam-portfolio/releases/tag/kali-portable-v1.0

🚀 ¿Qué herramientas necesitas para cada certificación de ciberseguridad?

Te lo resumo en mi nuevo proyecto "Kali Portable Full":

📗 eJPT (Junior):
→ Nmap, Metasploit, Burp Suite, Hydra
→ 100% cubierto ✅

📘 CEH (Intermedio):
→ +100 herramientas: Maltego, SET, Veil, SQLMap, APKTool
→ 100% cubierto ✅

📙 eCPPT (Profesional):
→ Active Directory: BloodHound, NetExec, Impacket
→ Pivoting: Chisel, SSHuttle, Ligolo-ng
→ 100% cubierto ✅

📕 OSCP (Avanzado):
→ Escaneo rápido: RustScan, Masscan
→ Explotación: Metasploit, SearchSploit
→ Pivoting: Proxychains, Chisel
→ 100% cubierto ✅

🎮 Plataformas:
→ TryHackMe: OpenVPN + todas las herramientas ✅
→ HackTheBox: OpenVPN + todas las herramientas ✅
→ VulnHub: Sin VPN, herramientas locales ✅

Todo esto en un contenedor Docker portable con GPU acceleration.

🔗 Link en los comentarios 👇

#Ciberseguridad #Pentesting #CEH #OSCP #eJPT #Ha
ckTheBox #TryHackMe #Docker #KaliLinux

🎨 Infografía de Cobertura
┌─────────────────────────────────────────────────────────────┐
│         KALI PORTABLE FULL - COBERTURA DE CERTIFICACIONES   │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  eJPT     ████████████████████████████████████████ 100% ✅  │
│  CEH      ████████████████████████████████████████ 100% ✅  │
│  eCPPT    ████████████████████████████████████████ 100% ✅  │
│  OSCP     ████████████████████████████████████████ 100% ✅  │
│  PNPT     ████████████████████████████████████████ 100% ✅  │
│                                                             │
│  TryHackMe ███████████████████████████████████████ 100% ✅  │
│  HackTheBox ██████████████████████████████████████ 100% ✅  │
│  VulnHub   ███████████████████████████████████████ 100% ✅  │
│                                                             │
└─────────────────────────────────────────────────────────────┘

"Con Kali Portable Full tienes TODO lo necesario para:
✅ Aprobar certificaciones desde eJPT hasta OSCP
✅ Practicar en plataformas como THM, HTB y VulnHub
✅ Trabajar como pentester profesional
✅ Todo en un USB portable con aceleración GPU  
No necesitas instalar nada más. Solo descarga, ejecuta y empieza a hackear éticamente."


# Unir, descomprimir y cargar
cat kali-pentest-full-part_* > kali-pentest-full.tar.gz
gunzip kali-pentest-full.tar.gz
docker load -i kali-pentest-full.tar

Luego en carpeta scripts ejecuta;
./scripts/install-on-new-pc.sh

El script hará automáticamente:

    ✅ Verificará que Docker esté instalado (lo instala si no está)
    ✅ Detectará tu GPU NVIDIA (configura el toolkit si falta)
    ✅ Cargará la imagen .tar en Docker
    ✅ Creará la estructura de carpetas data/
    ✅ Ajustará permisos para evitar errores de escritura
    ✅ Hará una prueba final para confirmar que todo funciona
---
```bash
## 📋 Descripción

**Kali Portable Full** es una imagen de Docker preconfigurada con un entorno completo de pentesting, optimizado para auditorías de seguridad, certificaciones profesionales (eJPT, eWPT, OSCP) y laboratorios de práctica (HackTheBox, TryHackMe).

La imagen incluye:
- ✅ Herramientas esenciales de pentesting preinstaladas y configuradas
- ✅ Soporte para aceleración por GPU NVIDIA (CUDA) para crackeo de hashes con Hashcat
- ✅ Diccionarios y reglas de Hashcat predescargados (Rockyou, SecLists, best64.rule, etc.)
- ✅ Sistema de volúmenes persistente para guardar tus hallazgos, reportes y handshakes
- ✅ Scripts de automatización para tareas comunes (crackeo WPA2, configuración WiFi)

Todo esto empaquetado en un contenedor portable que puedes ejecutar en cualquier sistema con Docker instalado, sin necesidad de instalar Kali Linux nativamente.

---

## ⚙️ Requisitos del Sistema

Antes de comenzar, asegúrate de cumplir con lo siguiente:

| Requisito | Detalle |
|-----------|---------|
| **Sistema Operativo** | Linux (recomendado), Windows 10/11 con WSL2, macOS |
| **Docker** | Versión 20.10 o superior instalado y funcionando |
| **GPU NVIDIA** (opcional) | Drivers NVIDIA instalados + NVIDIA Container Toolkit para aceleración por GPU |
| **Espacio en disco** | Mínimo 15 GB libres (la imagen ocupa ~8 GB + espacio para volúmenes) |
| **RAM** | Mínimo 4 GB (8 GB recomendado para herramientas como Burp Suite o Metasploit) |

### 🔧 Instalación de dependencias para GPU (Linux)

Si deseas aprovechar la aceleración por GPU para Hashcat, ejecuta esto en tu **sistema host** (no en el contenedor):

```bash
# Agregar repositorio de NVIDIA
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg
curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
  sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
  sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list

# Instalar toolkit
sudo apt update
sudo apt install -y nvidia-container-toolkit

# Configurar Docker y reiniciar
sudo nvidia-ctk runtime configure --runtime=docker
sudo systemctl restart docker

# Verificar que funciona
docker run --rm --gpus all nvidia/cuda:12.3.1-base-ubuntu22.04 nvidia-smi

📦 Instalación y Configuración
1. Clonar el repositorio

git clone https://github.com/diegoarriagadazamora/kali-portable-full.git
cd kali-portable-full

2. Cargar la imagen de Docker
Si descargaste el archivo .tar desde Releases:

docker load -i kali-pentest-full.tar

Si prefieres construir la imagen desde el Dockerfile incluido:
cd docker
docker build -t kali-pentest-full .

3. Preparar directorios de persistencia
El proyecto usa volúmenes para mantener tus datos entre sesiones. Crea la estructura base:
mkdir -p data/{scripts,wordlists,loot,reports,tools,handshakes,pcaps}

🚀 Modos de Ejecución
El script run-kali.sh permite ejecutar el contenedor en dos modos, según el tipo de auditoría que realizarás.
🔹 Modo normal (Recomendado para la mayoría de casos)
./run-kali.sh normal

¿Cuándo usarlo?

    Pentesting web (Burp Suite, SQLMap, Nuclei)
    Enumeración de redes y servicios (Nmap, RustScan)
    Active Directory / Red Team (netexec, BloodHound, Impacket)
    Laboratorios de HackTheBox, TryHackMe, eJPT, eWPT
    Cualquier tarea que no requiera acceso directo a hardware de red

Características:

    ✅ Red en modo host para escanear tu red local
    ✅ Soporte para interfaz gráfica (Burp, Wireshark) mediante X11 forwarding
    ✅ GPU habilitada si está disponible en el host
    ✅ Volúmenes persistentes montados en /root/pentest

🔹 Modo wpa2 (Para auditorías WiFi)
./run-kali.sh wpa2

¿Cuándo usarlo?

    Captura de handshakes WPA2/WPA3 con hcxdumptool o aircrack-ng
    Auditorías de redes inalámbricas que requieren modo monitor
    Inyección de paquetes y ataques de desautenticación

Características adicionales:

    ✅ Contenedor ejecutado con flag --privileged para acceso directo a hardware USB
    ✅ Permite que herramientas como hcxdumptool accedan a interfaces WiFi en modo monitor

    ⚠️ Nota: Para que el modo wpa2 funcione, necesitas un adaptador WiFi USB compatible con modo monitor (ej: Alfa AWUS036ACH con chipset RTL8812AU). Las tarjetas WiFi internas de laptops suelen no ser compatibles.

🛠️ Herramientas Incluidas
🔍 Reconocimiento y Enumeración

¿Cuándo usarlo?

    Captura de handshakes WPA2/WPA3 con hcxdumptool o aircrack-ng
    Auditorías de redes inalámbricas que requieren modo monitor
    Inyección de paquetes y ataques de desautenticación

Características adicionales:

    ✅ Contenedor ejecutado con flag --privileged para acceso directo a hardware USB
    ✅ Permite que herramientas como hcxdumptool accedan a interfaces WiFi en modo monitor

    ⚠️ Nota: Para que el modo wpa2 funcione, necesitas un adaptador WiFi USB compatible con modo monitor (ej: Alfa AWUS036ACH con chipset RTL8812AU). Las tarjetas WiFi internas de laptops suelen no ser compatibles.

🧭 Guía de Uso Rápido
1. Iniciar el contenedor
cd kali-portable-full
./run-kali.sh normal

Verás un banner de inicio y entrarás a una sesión bash como root@kali en /root/pentest.
2. Verificar que la GPU está disponible (opcional)
hashcat -I

Deberías ver algo como:
Platform #1: NVIDIA CUDA
  Name: GeForce 940MX
  Version: OpenCL 3.0 CUDA 12.x

3. Crackear un handshake WPA2 (ejemplo)
# Usar el script automatizado en modo rápido
auto-crack-wpa2.sh -q /root/pentest/handshakes/captura.pcapng

# O ejecutar Hashcat manualmente con GPU
hashcat -m 22000 -O -w 3 -D 2 \
  /root/pentest/handshakes/captura.hc22000 \
  /usr/share/wordlists/rockyou.txt \
  -r /usr/share/hashcat/rules/best64.rule \
  --force

4. Configurar adaptador WiFi para modo monitor (solo modo wpa2)
# Dentro del contenedor, con un adaptador USB conectado
setup-wifi.sh

El script detectará tu interfaz, detendrá servicios conflictivos y activará el modo monitor. Te indicará el nombre de la nueva interfaz (ej: wlan0mon) para usar con hcxdumptool.

5. Guardar tus resultados
Todo lo que guardes en /root/pentest/ dentro del contenedor se sincroniza automáticamente con la carpeta data/ en tu sistema host:
/root/pentest/loot/ data/loot/
/root/pentest/reports/ data/reports/
/root/pentest/handshakes/ data/handshakes/

6. Salir del contenedor
exit
# o presionar Ctrl + D

🎯 Casos de Uso Recomendados
🎓 Certificaciones (eJPT, eWPT, OSCP)

    Conecta la VPN del laboratorio desde tu sistema host.
    El contenedor usa --network host, por lo que heredará la conexión automáticamente.
    Usa nmap, gobuster, sqlmap y burpsuite para enumerar y explotar objetivos.
    Guarda tus hallazgos en /root/pentest/reports/ para incluirlos en tu informe final.

🧪 Laboratorios de Práctica (HackTheBox, TryHackMe)

    Accede a las máquinas objetivo mediante su IP o nombre de host.
    Usa netexec para enumerar servicios SMB, bloodhound-python para mapear dominios AD.
    Crakea hashes obtenidos con hashcat aprovechando tu GPU local.

🏢 Auditorías de Active Directory
# Enumerar usuarios y grupos
nxe smb 192.168.1.0/24 -u usuario -p 'password' --users --groups

# Recolectar datos para BloodHound
bloodhound-python -d DOMINIO.local -u usuario -p 'password' -c All -ns 192.168.1.1

# Extraer hashes con secretsdump
secretsdump.py DOMINIO/usuario:'password'@192.168.1.10

📡 Auditorías WiFi (WPA2/WPA3)
# 1. Entrar en modo wpa2 con adaptador USB conectado
./run-kali.sh wpa2

# 2. Configurar modo monitor
setup-wifi.sh

# 3. Capturar handshake
hcxdumptool -i wlan0mon -o /root/pentest/handshakes/captura.pcapng --enable_status=1

# 4. Crackear con el script automatizado
auto-crack-wpa2.sh -q /root/pentest/handshakes/captura.pcapng

📁 Estructura del Proyecto
kali-portable-full/
├── docker/
│   └── Dockerfile              # Definición de la imagen Docker
├── scripts/
│   ├── run-kali.sh             # Script principal de ejecución
│   ├── auto-crack-wpa2.sh      # Automatización de crackeo WPA2
│   └── setup-wifi.sh           # Configuración de modo monitor WiFi
├── data/                       # ← Carpeta de persistencia (se crea al ejecutar)
│   ├── handshakes/             # Archivos .pcapng y .hc22000
│   ├── loot/                   # Contraseñas encontradas, dumps
│   ├── reports/                # Informes, screenshots, logs
│   ├── scripts/                # Tus scripts personalizados
│   ├── tools/                  # Herramientas descargadas manualmente
│   └── wordlists/              # Diccionarios adicionales
├── README.md                   # Este archivo
└── LICENSE                     # Licencia de uso

⚠️ Consideraciones de Seguridad y Legalidad

    Este proyecto está diseñado exclusivamente para fines educativos, de investigación y auditorías de seguridad autorizadas.

    🔐 Nunca utilices estas herramientas en redes o sistemas que no te pertenezcan o para los cuales no tengas autorización explícita por escrito.
    📜 El uso indebido de herramientas de pentesting puede constituir un delito en muchas jurisdicciones.
    🤝 El autor no se hace responsable por el uso inadecuado de este software.

🔄 Actualización y Mantenimiento
Actualizar la imagen
Si se publica una nueva versión en Releases:
# Descargar nueva imagen
docker load -i kali-pentest-full-v2.tar

# (Opcional) Eliminar versión anterior
docker rmi kali-pentest-full:latest

Reconstruir desde Dockerfile
Si modificas el Dockerfile:
cd docker
docker build -t kali-pentest-full .

Exportar tu imagen personalizada
Si agregas herramientas o configuraciones y quieres guardar tu versión:
docker save -o mi-kali-personalizada.tar kali-pentest-full

🆘 Solución de Problemas Comunes

hashcat -I no detecta GPU
Verifica que instalaste NVIDIA Container Toolkit en el host y que ejecutas con --gpus all

Burp Suite no abre ventana gráfica
Ejecuta xhost +local:docker en tu host antes de entrar al contenedor

hcxdumptool no detecta interfaz WiFi
Asegúrate de usar ./run-kali.sh wpa2 y que tu adaptador USB es compatible con modo monitor

Archivos no aparecen en data/
Verifica que estás guardando en /root/pentest/ dentro del contenedor, no en otra ruta

Error de permisos al escribir en volúmenes
Ejecuta: sudo chown -R $USER:$USER data/ en tu host

🤝 Contribuciones
¿Encontraste un error o tienes una mejora? ¡Las contribuciones son bienvenidas!

    Haz un fork del repositorio
    Crea una rama para tu feature (git checkout -b feature/nueva-herramienta)
    Commit tus cambios (git commit -m 'Agregar: nueva herramienta')
    Push a la rama (git push origin feature/nueva-herramienta)
    Abre un Pull Request

📄 Licencia
Este proyecto está bajo la Licencia MIT. Ver el archivo LICENSE
 para más detalles.

<div align="center">
🔐 Kali Portable Full — Potencia, Portabilidad y Profesionalismo
Autor: Diego Arriagada Zamora
GitHub: diegoarriagadazamora

LinkedIn: Diego Arriagada
Úsalo con responsabilidad. Aprende con propósito. Audita con ética.
</div>
```
