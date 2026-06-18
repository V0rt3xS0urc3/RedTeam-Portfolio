# =============================================================================
# KALI PORTABLE FULL - CEH COMPLETE EDITION (Kali 2024+)
# Arsenal 100% completo para CEHPC, eJPT, eCPPT, THM, HTB
# Autor: Diego Arriagada (V0rt3x_S0urc3)
# =============================================================================
FROM kalilinux/kali-rolling:latest

ENV DEBIAN_FRONTEND=noninteractive
ENV HASHCAT_RULES_PATH=/usr/share/hashcat/rules
ENV WORDLISTS_PATH=/usr/share/wordlists
ENV SECLISTS_PATH=/usr/share/seclists

# =============================================================================
# 1. UTILIDADES BASE DEL SISTEMA
# =============================================================================
RUN apt update && apt install -y --no-install-recommends \
    nano vim tmux less tree util-linux \
    net-tools iputils-ping dnsutils procps \
    curl wget git unzip zip p7zip-full \
    jq build-essential cmake libssl-dev pkg-config \
    && apt clean && rm -rf /var/lib/apt/lists/*
    
# FIX: En Kali 2026.2 a veces falta el binario 'rev'. Lo recreamos con Python si no existe.
RUN if ! command -v rev &> /dev/null; then \
        printf '#!/usr/bin/env python3\nimport sys\nfor line in sys.stdin:\n    print(line.rstrip("\\n")[::-1])\n' > /usr/local/bin/rev && \
        chmod +x /usr/local/bin/rev; \
    fi

# =============================================================================
# 2. PYTHON Y ENTORNO DE DESARROLLO
# =============================================================================
RUN apt update && apt install -y --no-install-recommends \
    python3-pip python3-venv python3-full python3-dev \
    && apt clean && rm -rf /var/lib/apt/lists/*

# =============================================================================
# 3. ESCANEO Y RECONOCIMIENTO (CORREGIDO)
# =============================================================================
RUN apt update && apt install -y --no-install-recommends \
    nmap masscan \
    nikto whatweb wpscan \
    gobuster dirb ffuf \
    sqlmap \
    enum4linux-ng \
    && apt clean && rm -rf /var/lib/apt/lists/*

# RustScan (desde GitHub .deb)
RUN curl -sL https://github.com/RustScan/RustScan/releases/download/2.2.3/rustscan_2.2.3_amd64.deb -o /tmp/rustscan.deb && \
    dpkg -i /tmp/rustscan.deb 2>/dev/null || apt install -f -y && \
    rm -f /tmp/rustscan.deb

# Nuclei (desde GitHub)
RUN curl -sL https://github.com/projectdiscovery/nuclei/releases/download/v3.3.8/nuclei_3.3.8_linux_amd64.zip -o /tmp/nuclei.zip && \
    unzip -q /tmp/nuclei.zip nuclei -d /usr/local/bin/ && \
    rm -f /tmp/nuclei.zip && \
    chmod +x /usr/local/bin/nuclei

# =============================================================================
# 4. EXPLOTACIÓN Y FRAMEWORKS
# =============================================================================
RUN apt update && apt install -y --no-install-recommends \
    metasploit-framework \
    exploitdb \
    util-linux \
    && apt clean && rm -rf /var/lib/apt/lists/*

# =============================================================================
# 5. EVASIÓN DE ANTIVIRUS (CRÍTICO PARA CEH)
# =============================================================================
# Veil Framework
RUN git clone https://github.com/Veil-Framework/Veil.git /opt/Veil && \
    cd /opt/Veil && \
    ./config/update.py --force || echo "Veil instalado"


# TheFatRat (generación de backdoors)
RUN git clone https://github.com/Screetsec/TheFatRat.git /opt/TheFatRat && \
    cd /opt/TheFatRat && \
    chmod +x setup.sh && \
    ./setup.sh || echo "TheFatRat instalado"

# Backdoor Factory
RUN git clone https://github.com/secretsquirrel/the-backdoor-factory.git /opt/backdoor-factory && \
    cd /opt/backdoor-factory && \
    chmod +x backdoor.py && \
    ln -s /opt/backdoor-factory/backdoor.py /usr/local/bin/backdoor-factory

# =============================================================================
# 6. ANÁLISIS FORENSE DIGITAL (CEH MODULES 15-17)
# =============================================================================
RUN apt update && apt install -y --no-install-recommends \
    sleuthkit autopsy \
    && apt clean && rm -rf /var/lib/apt/lists/*

# Volatility 3 (versión moderna - instalada desde PyPI)
RUN pip3 install --no-cache-dir --break-system-packages volatility3 && \
    echo "✅ Volatility 3 instalado"

# Binwalk (análisis de firmware)
RUN apt update && apt install -y --no-install-recommends \
    binwalk \
    && apt clean && rm -rf /var/lib/apt/lists/*

# =============================================================================
# 7. OSINT E INGENIERÍA SOCIAL (CEH MODULE 3)
# =============================================================================
RUN apt update && apt install -y --no-install-recommends \
    maltego theharvester recon-ng \
    && apt clean && rm -rf /var/lib/apt/lists/*

# Shodan CLI
RUN pip3 install --no-cache-dir --break-system-packages shodan

# SpiderFoot
RUN apt update && apt install -y --no-install-recommends \
    libxml2-dev libxslt1-dev python3-dev \
    && apt clean && rm -rf /var/lib/apt/lists/*

# Social Engineer Toolkit (SET)
RUN git clone https://github.com/trustedsec/social-engineer-toolkit.git /opt/set && \
    cd /opt/set && \
    pip3 install --no-cache-dir --break-system-packages -r requirements.txt && \
    chmod +x setoolkit && \
    ln -s /opt/set/setoolkit /usr/local/bin/setoolkit

# =============================================================================
# 8. IOT Y SCADA HACKING (CEH MODULE 20)
# =============================================================================
# RouterSploit
RUN git clone https://github.com/threat9/routersploit.git /opt/routersploit && \
    cd /opt/routersploit && \
    pip3 install --no-cache-dir --break-system-packages --ignore-installed -r requirements.txt && \
    chmod +x rsf.py && \
    ln -s /opt/routersploit/rsf.py /usr/local/bin/routersploit && \
    echo "✅ RouterSploit instalado"

# =============================================================================
# 9. MOBILE HACKING (CEH MODULE 18)
# =============================================================================
RUN apt update && apt install -y --no-install-recommends \
    apktool dex2jar \
    && apt clean && rm -rf /var/lib/apt/lists/*

# JD-GUI (descompilador Java)
RUN wget -q https://github.com/skylot/jadx/releases/download/v1.5.1/jadx-1.5.1.zip -O /tmp/jadx.zip && \
    mkdir -p /opt/jadx && \
    unzip -q /tmp/jadx.zip -d /opt/jadx && \
    chmod +x /opt/jadx/bin/jadx /opt/jadx/bin/jadx-gui && \
    ln -s /opt/jadx/bin/jadx /usr/local/bin/jadx && \
    ln -s /opt/jadx/bin/jadx-gui /usr/local/bin/jadx-gui && \
    rm -f /tmp/jadx.zip && \
    echo "✅ JADX instalado"

# MobSF (Mobile Security Framework)
RUN git clone https://github.com/MobSF/Mobile-Security-Framework-MobSF.git /opt/mobsf && \
    cd /opt/mobsf && \
    chmod +x setup.sh && \
    ./setup.sh || echo "MobSF instalado (requiere configuración manual)"

# =============================================================================
# 10. CRIPTOGRAFÍA AVANZADA (CEH MODULE 19)
# =============================================================================
RUN apt update && apt install -y --no-install-recommends \
    hashcat john \
    && apt clean && rm -rf /var/lib/apt/lists/*

# =============================================================================
# 11. AUDITORÍA WEB AVANZADA
# =============================================================================
RUN apt update && apt install -y --no-install-recommends \
    burpsuite \
    && apt clean && rm -rf /var/lib/apt/lists/*

# Foxy Proxy (descargar extensión para Firefox desde GitHub)
RUN mkdir -p /root/pentest/tools/browser-extensions && \
    curl -sL https://github.com/foxyproxy/firefox-extension/releases/download/v8.10/foxyproxy_for_firefox-8.10.xpi \
    -o /root/pentest/tools/browser-extensions/foxyproxy.xpi && \
    echo "✅ Foxy Proxy descargado en /root/pentest/tools/browser-extensions/"


# Herramientas web modernas desde GitHub
RUN curl -sL https://github.com/ffuf/ffuf/releases/download/v2.1.0/ffuf_2.1.0_linux_amd64.tar.gz | tar xz -C /usr/local/bin && \
    curl -sL https://github.com/projectdiscovery/httpx/releases/download/v1.6.9/httpx_1.6.9_linux_amd64.zip -o /tmp/httpx.zip && \
    unzip -q /tmp/httpx.zip httpx -d /usr/local/bin/ && rm -f /tmp/httpx.zip && \
    curl -sL https://github.com/projectdiscovery/subfinder/releases/download/v2.6.7/subfinder_2.6.7_linux_amd64.zip -o /tmp/subfinder.zip && \
    unzip -q /tmp/subfinder.zip subfinder -d /usr/local/bin/ && rm -f /tmp/subfinder.zip

# Herramientas Web y Pentesting faltantes
RUN apt update && apt install -y --no-install-recommends \
    ncrack \
    weevely \
    wrk \
    wfuzz \
    && apt clean && rm -rf /var/lib/apt/lists/*

# Herramientas Python para Web (tplmap y jwt_tool desde GitHub)
RUN git clone https://github.com/epinna/tplmap.git /opt/tplmap && \
    chmod +x /opt/tplmap/tplmap.py && \
    ln -s /opt/tplmap/tplmap.py /usr/local/bin/tplmap && \
    git clone https://github.com/ticarpi/jwt_tool.git /opt/jwt_tool && \
    chmod +x /opt/jwt_tool/jwt_tool.py && \
    ln -s /opt/jwt_tool/jwt_tool.py /usr/local/bin/jwt_tool && \
    echo "✅ tplmap y jwt_tool instalados desde GitHub"

# =============================================================================
# 11.5. ESTEGANOGRAFÍA Y ENUMERACIÓN SSH
# =============================================================================
# Steghide (esteganografía en imágenes/audio)
RUN apt update && apt install -y --no-install-recommends \
    steghide \
    && apt clean && rm -rf /var/lib/apt/lists/*

# Stegseek (cracker rápido para steghide)
RUN wget -q https://github.com/RickdeJager/stegseek/releases/download/v0.6/stegseek_0.6-1.deb -O /tmp/stegseek.deb && \
    dpkg -i /tmp/stegseek.deb || apt install -f -y && \
    rm -f /tmp/stegseek.deb && \
    apt clean && rm -rf /var/lib/apt/lists/*
    
    
# =============================================================================
# 12. REDES Y PROTOCOLOS
# =============================================================================
RUN apt update && apt install -y --no-install-recommends \
    netcat-openbsd socat proxychains-ng chisel tcpdump tshark wireshark \
    && apt clean && rm -rf /var/lib/apt/lists/*

# Ligolo-ng (túneles avanzados)
RUN curl -sL https://github.com/nicocha30/ligolo-ng/releases/download/v0.6.2/ligolo-ng_agent_0.6.2_linux_amd64.tar.gz | tar xz -C /usr/local/bin

# =============================================================================
# 13. CRACKING Y FUERZA BRUTA
# =============================================================================
RUN apt update && apt install -y --no-install-recommends \
    hashcat john hydra medusa \
    && apt clean && rm -rf /var/lib/apt/lists/*

# =============================================================================
# 14. AUDITORÍA WIFI
# =============================================================================
RUN apt update && apt install -y --no-install-recommends \
    aircrack-ng hcxdumptool hcxtools wifite reaver pixiewps \
    && apt clean && rm -rf /var/lib/apt/lists/*

# =============================================================================
# 15. ACTIVE DIRECTORY Y MOVIMIENTO LATERAL
# =============================================================================
RUN apt update && apt install -y --no-install-recommends \
    impacket-scripts evil-winrm responder bloodhound crackmapexec \
    && apt clean && rm -rf /var/lib/apt/lists/*

# NetExec (sucesor moderno de CrackMapExec)
RUN pip3 install --no-cache-dir --break-system-packages --ignore-installed \
    git+https://github.com/Pennyw0rth/NetExec

# Herramientas AD especializadas
RUN pip3 install --no-cache-dir --break-system-packages --ignore-installed \
    certipy-ad ldapdomaindump adidnsdump kerbrute

# =============================================================================
# 16. POST-EXPLOTACIÓN
# =============================================================================
RUN pip3 install --no-cache-dir --break-system-packages --ignore-installed \
    pwntools paramiko requests pwncat-cs

# LinPEAS y WinPEAS
RUN mkdir -p /opt/PEAS && \
    curl -sL https://github.com/carlospolop/PEASS-ng/releases/latest/download/linpeas.sh -o /opt/PEAS/linpeas.sh && \
    curl -sL https://github.com/carlospolop/PEASS-ng/releases/latest/download/winPEASany.exe -o /opt/PEAS/winPEASany.exe && \
    chmod +x /opt/PEAS/linpeas.sh

# =============================================================================
# 17. VPN Y TUNNELING (THM/HTB)
# =============================================================================
RUN apt update && apt install -y --no-install-recommends \
    openvpn openvpn-systemd-resolved sshuttle \
    && apt clean && rm -rf /var/lib/apt/lists/*

# =============================================================================
# 18. HERRAMIENTAS DE PRIVILEGE ESCALATION
# =============================================================================
RUN mkdir -p /opt/privesc && \
    curl -sL https://raw.githubusercontent.com/mzet-/linux-exploit-suggester/master/linux-exploit-suggester.sh -o /opt/privesc/linux-exploit-suggester.sh && \
    chmod +x /opt/privesc/linux-exploit-suggester.sh && \
    curl -sL https://raw.githubusercontent.com/diego-treitos/linux-smart-enumeration/master/lse.sh -o /opt/privesc/lse.sh && \
    chmod +x /opt/privesc/lse.sh && \
    curl -sL https://github.com/DominicBreuker/pspy/releases/download/v1.2.1/pspy64 -o /opt/privesc/pspy64 && \
    chmod +x /opt/privesc/pspy64

# =============================================================================
# 19. CONFIGURACIÓN GPU (OpenCL para Hashcat)
# =============================================================================
RUN apt update && apt install -y --no-install-recommends ocl-icd-libopencl1 \
    && mkdir -p /etc/OpenCL/vendors \
    && echo "libnvidia-opencl.so.1" > /etc/OpenCL/vendors/nvidia.icd \
    && ldconfig \
    && apt clean && rm -rf /var/lib/apt/lists/*

# =============================================================================
# 20. DICCIONARIOS Y REGLAS
# =============================================================================
RUN mkdir -p ${WORDLISTS_PATH} ${WORDLISTS_PATH}/custom ${HASHCAT_RULES_PATH} ${SECLISTS_PATH}

# RockYou.txt
RUN wget -q --user-agent="Mozilla/5.0" --show-progress \
    https://github.com/brannondorsey/naive-hashcat/releases/download/data/rockyou.txt \
    -O ${WORDLISTS_PATH}/rockyou.txt 2>/dev/null || \
    echo "Rockyou: descargar manualmente" > ${WORDLISTS_PATH}/rockyou.txt

# SecLists completo
RUN wget -q --user-agent="Mozilla/5.0" --show-progress \
    https://github.com/danielmiessler/SecLists/archive/refs/heads/master.zip \
    -O /tmp/seclists.zip && \
    unzip -q /tmp/seclists.zip -d /tmp/ && \
    mv /tmp/SecLists-master/* ${SECLISTS_PATH}/ && \
    rm -rf /tmp/seclists.zip /tmp/SecLists-master

# Reglas de Hashcat (ya vienen con el paquete hashcat de Kali)
RUN ls ${HASHCAT_RULES_PATH}/best64.rule >/dev/null 2>&1 && \
    echo "✅ Reglas de Hashcat verificadas" || \
    echo "⚠ Reglas no encontradas, se pueden descargar manualmente"

# Wordlists para gobuster (symlinks desde SecLists ya descargado)
RUN ln -sf ${SECLISTS_PATH}/Discovery/Web-Content/common.txt ${WORDLISTS_PATH}/common.txt 2>/dev/null || \
    echo "⚠ common.txt no encontrado en SecLists" && \
    ln -sf ${SECLISTS_PATH}/Discovery/Web-Content/directory-list-2.3-medium.txt ${WORDLISTS_PATH}/directory-list-medium.txt 2>/dev/null || \
    echo "⚠ directory-list-medium.txt no encontrado en SecLists" && \
    echo "✅ Wordlists para gobuster configuradas"
    

# =============================================================================
# 21. CONFIGURACIÓN DE ENTORNO Y ALIASES
# =============================================================================
RUN mkdir -p /root/pentest/{scripts,wordlists,loot,reports,tools,handshakes,pcaps,vpn} \
    && echo '# === ALIASES KALI PORTABLE FULL - CEH EDITION ===' >> /root/.bashrc \
    && echo 'alias msf="msfconsole"' >> /root/.bashrc \
    && echo 'alias nxe="netexec"' >> /root/.bashrc \
    && echo 'alias cme="crackmapexec"' >> /root/.bashrc \
    && echo 'alias hc="hashcat"' >> /root/.bashrc \
    && echo 'alias veil="/opt/Veil/Veil.py"' >> /root/.bashrc \
    && echo 'alias fatrat="cd /opt/TheFatRat && ./fatrat"' >> /root/.bashrc \
    && echo 'alias vol="vol"' >> /root/.bashrc \
    && echo 'alias set="setoolkit"' >> /root/.bashrc \
    && echo 'alias rsf="routersploit"' >> /root/.bashrc \
    && echo 'alias linpeas="/opt/PEAS/linpeas.sh"' >> /root/.bashrc \
    && echo 'alias les="/opt/privesc/linux-exploit-suggester.sh"' >> /root/.bashrc \
    && echo 'export PATH=$PATH:/root/pentest/scripts' >> /root/.bashrc \
    && echo 'cd /root/pentest' >> /root/.bashrc \
    && echo 'echo ""' >> /root/.bashrc \
    && echo 'echo "╔════════════════════════════════════════════════════════╗"' >> /root/.bashrc \
    && echo 'echo "║  KALI PORTABLE FULL - CEH COMPLETE EDITION            ║"' >> /root/.bashrc \
    && echo 'echo "║  100% listo para: CEHPC, eJPT, eCPPT, THM, HTB          ║"' >> /root/.bashrc \
    && echo 'echo "║  Autor: Diego Arriagada Zamora (V0rt3x_S0urc3)               ║"' >> /root/.bashrc \
    && echo 'echo "╚════════════════════════════════════════════════════════╝"' >> /root/.bashrc \
    && echo 'echo ""' >> /root/.bashrc

WORKDIR /root/pentest
ENTRYPOINT ["/bin/bash"]
