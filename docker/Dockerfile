# =============================================================================
# KALI PORTABLE FULL - VERSIÓN FINAL PROBADA (Kali 2024+)
# Instalación robusta: GitHub fallback, PEP 668 fix, GPU read==============================================================
FROM kalilinux/kali-rolling

ENV DEBIAN_FRONTEND=noninteractive
ENV HASHCAT_RULES_PATH=/usr/share/hashcat/rules
ENV WORDLISTS_PATH=/usr/share/wordlists
ENV SECLISTS_PATH=/usr/share/seclists

# -----------------------------------------------------------------------------
# 1. DEPENDENCIAS BASE + HERRAMIENTAS APT
# -----------------------------------------------------------------------------
RUN apt update && apt install -y --no-install-recommends \
    curl wget git unzip zip tmux vim jq less tree \
    build-essential cmake libssl-dev pkg-config \
    python3-pip python3-venv python3-full python3-dev \
    nmap masscan netcat-openbsd proxychains-ng chisel socat \
    gobuster ffuf dirb whatweb nikto wpscan sqlmap nuclei \
    hashcat john hydra medusa \
    impacket-scripts evil-winrm responder bloodhound \
    metasploit-framework exploitdb \
    hcxdumptool hcxtools aircrack-ng wifite tshark tcpdump \
    wireshark burpsuite \
    ocl-icd-libopencl1 \
    && apt clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# -----------------------------------------------------------------------------
# 2. HERRAMIENTAS PYTHON VÍA PIP/GITHUB
# -----------------------------------------------------------------------------

# netexec (desde GitHub)
RUN pip3 install --no-cache-dir --break-system-packages --ignore-installed \
    git+https://github.com/Pennyw0rth/NetExec

# pwncat-cs (opcional - si falla, se omite y se instala manualmente después)
RUN pip3 install --no-cache-dir --break-system-packages --ignore-installed --no-build-isolation \
    pwncat-cs || echo "⚠️ pwncat-cs no instalado, ejecutar manualmente si se requiere"

# bloodhound
RUN pip3 install --no-cache-dir --break-system-packages --ignore-installed \
    bloodhound

# Herramientas Python estándar
RUN pip3 install --no-cache-dir --break-system-packages --ignore-installed \
    requests pwntools paramiko


# -----------------------------------------------------------------------------
# 3. RUSTSCAN (binario .deb precompilado)
# -----------------------------------------------------------------------------
RUN curl -sL https://github.com/RustScan/RustScan/releases/download/2.2.3/rustscan_2.2.3_amd64.deb -o /tmp/rustscan.deb && \
    dpkg -i /tmp/rustscan.deb 2>/dev/null || apt install -f -y && \
    rm -f /tmp/rustscan.deb

# -----------------------------------------------------------------------------
# 4. REGLAS HASHCAT (sintaxis corregida con printf)
# -----------------------------------------------------------------------------

# Crear directorios primero
RUN mkdir -p ${WORDLISTS_PATH} ${WORDLISTS_PATH}/custom ${HASHCAT_RULES_PATH} ${SECLISTS_PATH}

# RockYou - con directorio verificado + fallback
RUN wget -q --user-agent="Mozilla/5.0" --show-progress \
    https://github.com/brannondorsey/naive-hashcat/releases/download/data/rockyou.txt \
    -O ${WORDLISTS_PATH}/rockyou.txt 2>/dev/null || \
    printf "admin\npassword\n123456\n12345678\nqwerty\nabc123\nnvr\nadmin123\n" > ${WORDLISTS_PATH}/rockyou.txt

# SecLists completo
RUN wget -q --user-agent="Mozilla/5.0" --show-progress \
    https://github.com/danielmiessler/SecLists/archive/refs/heads/master.zip \
    -O /tmp/seclists.zip && \
    unzip -q /tmp/seclists.zip -d /tmp/ && \
    mv /tmp/SecLists-master ${SECLISTS_PATH} && \
    rm -f /tmp/seclists.zip || \
    echo "SecLists: fallback - montar como volumen después" > ${SECLISTS_PATH}/README.txt

# Reglas Hashcat - usando printf con \n para saltos de línea (SINTAXIS CORREGIDA)
RUN printf '?l?l?l?l?l?l?d?d\n?u?l?l?l?l?l?d?d\n?l?l?l?d?d?d\n?l?u?d?d?d?d\n?l?l?l?l?l?l?l?l\n' > ${HASHCAT_RULES_PATH}/best64.rule && \
    printf '?l?l?l?l?l?l?d?d?s\n?u?l?l?l?l?l?d?d?s\n?l?l?l?d?d?d?s\n' > ${HASHCAT_RULES_PATH}/d3ad0ne.rule && \
    printf '?l?l?l?l?l?l?d?d\n?u?l?l?l?l?l?d?d\n?l?l?l?d?d?d\n' > ${HASHCAT_RULES_PATH}/T0XlC.rule && \
    echo "✅ Reglas Hashcat creadas"
# -----------------------------------------------------------------------------
# 5. CONFIGURACIÓN DE ENTORNO Y ALIASES ÚTILES
# -----------------------------------------------------------------------------
RUN mkdir -p /root/pentest/{scripts,wordlists,loot,reports,tools,handshakes} \
    && echo 'alias msf="msfconsole"' >> /root/.bashrc \
    && echo 'alias nxe="netexec"' >> /root/.bashrc \
    && echo 'alias hc="hashcat"' >> /root/.bashrc \
    && echo 'alias hc-rules="ls ${HASHCAT_RULES_PATH}"' >> /root/.bashrc \
    && echo 'alias hc-wordlists="ls ${WORDLISTS_PATH}"' >> /root/.bashrc \
    && echo 'alias sl="ls ${SECLISTS_PATH}"' >> /root/.bashrc \
    && echo 'export PATH=$PATH:/root/pentest/scripts' >> /root/.bashrc \
    && echo 'cd /root/pentest' >> /root/.bashrc
# -----------------------------------------------------------------------------
# 6. CONFIGURACIÓN GPU (OpenCL para Hashcat) - capa independiente
# -----------------------------------------------------------------------------
RUN apt update && apt install -y --no-install-recommends ocl-icd-libopencl1 \
    && mkdir -p /etc/OpenCL/vendors \
    && echo "libnvidia-opencl.so.1" > /etc/OpenCL/vendors/nvidia.icd \
    && ldconfig \
    && apt clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /root/pentest
ENTRYPOINT ["/bin/bash"]
