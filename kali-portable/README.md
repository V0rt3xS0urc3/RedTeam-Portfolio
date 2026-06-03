# 🔐 Kali Portable Full - Red Team Edition

**Estación de pentesting completa en Docker con aceleración GPU**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Docker](https://img.shields.io/badge/Docker-Ready-blue.svg)](https://www.docker.com/)
[![GPU](https://img.shields.io/badge/GPU-NVIDIA%20CUDA-green.svg)](https://developer.nvidia.com/cuda-zone)

---

## 🚀 Instalación en 3 Comandos

```bash
# 1. Clonar el repositorio
git clone https://github.com/V0rt3xS0urc3/RedTeam-Portfolio.git
cd RedTeam-Portfolio/kali-portable

# 2. Ejecutar el instalador automático
chmod +x scripts/install-on-new-pc.sh
./scripts/install-on-new-pc.sh

El instalador automáticamente:

    ✅ Instala Docker (si no está)
    ✅ Configura GPU NVIDIA (si está disponible)
    ✅ Construye la imagen Docker con 100+ herramientas
    ✅ Descarga rockyou.txt (~133 MB)
    ✅ Descarga reglas de Hashcat
    ✅ Descarga wordlists para gobuster
    ✅ Configura permisos
    ✅ Hace pruebas finales

El usuario no tiene que hacer NADA manualmente. Todo es automático.

## 📚 Diccionarios Incluidos

El instalador descarga automáticamente:

- **rockyou.txt** (~133 MB) - El diccionario más famoso de filtraciones
- **Reglas de Hashcat** - best64.rule, d3ad0ne.rule, T0XlC.rule, leetspeak.rule
- **Wordlists para gobuster** - common.txt

Todos se descargan durante la instalación desde fuentes oficiales (Kali Linux, GitHub).



# 3. ¡Listo! Iniciar el entorno
./run-kali.sh normal

Tiempo de instalación: ~30-45 minutos (depende de tu conexión a internet)

📦 ¿Qué incluye?
🛠️ Arsenal Completo de Red Team
🔍 Escaneo y Reconocimiento

    Nmap, Masscan, RustScan - Escáneres de red
    Nikto, WhatWeb, WPScan - Escáneres web
    Gobuster, Dirb, FFUF - Fuzzing de directorios
    SQLMap, Nuclei - Vulnerabilidades web

💥 Explotación

    Metasploit Framework - Plataforma de explotación
    Impacket, NetExec, CrackMapExec - Active Directory
    BloodHound - Análisis de relaciones AD
    
    🌐 Auditoría Web

    Burp Suite Community - Proxy interceptor
    SQLMap - SQL Injection automático
    Gobuster, FFUF, Wfuzz - Fuzzing avanzado

📡 Auditoría WiFi y Cracking

    Hashcat - Con aceleración GPU NVIDIA CUDA
    Aircrack-ng Suite - Modo monitor y análisis
    Hydra, John the Ripper - Fuerza bruta

🛡️ Evasión de Antivirus

    Veil Framework - Generación de payloads evasivos
    Shellter - Inyección de payloads
    TheFatRat - Generación de backdoors
    
🔬 Análisis Forense

    Volatility 3 - Análisis de memoria
    Binwalk - Análisis de firmware
    Sleuth Kit - Análisis forense de discos

📱 Mobile Hacking

    APKTool, Dex2Jar - Ingeniería inversa Android
    JD-GUI - Descompilador Java
    MobSF - Mobile Security Framework

🌐 IoT y SCADA

    RouterSploit - Framework para routers
    Binwalk - Análisis de firmware

🔐 OSINT e Ingeniería Social

    Maltego - Análisis visual de relaciones
    theHarvester, Shodan CLI - Recolección de información
    Social Engineer Toolkit (SET) - Ingeniería social

🏢 Active Directory

    Impacket Suite - Protocolos Windows
    BloodHound - Análisis de rutas de ataque
    NetExec, CrackMapExec - Movimiento lateral
    Certipy, Kerbrute - Ataques AD especializados

🌐 Redes y Tunneling

    Wireshark, TCPDump - Análisis de tráfico
    Chisel, Ligolo-ng, SSHuttle - Túneles y pivoting
    OpenVPN - Conexión a THM/HTB
    
⚙️ Post-Explotación

    LinPEAS, WinPEAS - Enumeración automática
    Linux Exploit Suggester - Sugerencias de privesc
    Pwncat - Shell mejorada
    
    🎮 Plataformas de Práctica

    ✅ TryHackMe - Con OpenVPN configurado
    ✅ HackTheBox - Con OpenVPN configurado
    ✅ VulnHub - VMs locales
    
    📖 Uso
Modo Normal (Pentesting General + GPU)

```bash
./run-kali.sh normal

Modo WPA2 (Auditoría WiFi)

```bash
./run-kali.sh wpa2

Conectar a TryHackMe/HackTheBox
```bash
# Dentro del contenedor
openvpn --config /root/pentest/vpn/tu_archivo.ovpn --dev tun

📂 Estructura del Proyecto

kali-portable/
├── docker/
│   └── Dockerfile              # Receta de construcción
├── scripts/
│   ├── run-kali.sh            # Lanzador principal
│   ├── install-on-new-pc.sh   # Instalador automático
│   ├── auto-crack-wpa2.sh     # Crackeo WPA2
│   └── setup-wifi.sh          # Modo monitor
├── data/                       # Volumen persistente
│   ├── wordlists/             # Diccionarios
│   ├── rules/                 # Reglas de Hashcat
│   ├── handshakes/            # Capturas WiFi
│   ├── loot/                  # Resultados
│   └── vpn/                   # Archivos VPN
├── README.md
└── LICENSE

🔧 Requisitos

    Docker 20.10 o superior
    NVIDIA Container Toolkit (opcional, para GPU)
    ~15 GB de espacio libre en disco
    Conexión a internet para descargar paquetes durante la construcción
    Adaptador WiFi USB compatible con modo monitor (solo para auditoría WiFi)
    
    🤝 Contribuir
Las contribuciones son bienvenidas. Si quieres agregar una herramienta o mejorar el proyecto:

    Fork el repositorio
    Crea una rama para tu feature (git checkout -b feature/NuevaHerramienta)
    Commit tus cambios (git commit -m 'Agregar nueva herramienta')
    Push a la rama (git push origin feature/NuevaHerramienta)
    Abre un Pull Request
    
    📝 Licencia
Este proyecto está bajo la licencia MIT - ver el archivo LICENSE
 para más detalles.
 
 👤 Autor
Diego Arriagada (V0rt3x_S0urc3)

    GitHub: @V0rt3xS0urc3
    LinkedIn: Diego Arriagada
    
    ⚠️ Disclaimer
Este proyecto es para fines educativos y auditorías autorizadas. El uso indebido de estas herramientas es responsabilidad exclusiva del usuario. Respeta siempre las leyes y obtén autorización antes de realizar pruebas de penetración.

🔥 ¿Te gustó el proyecto? Dale una estrella ⭐ en GitHub!

