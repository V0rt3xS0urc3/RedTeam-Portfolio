#!/bin/bash

# =============================================================================
# SCRIPT UNIVERSAL KALI PORTABLE - Detecta GPU automáticamente
# Creado por: Diego Arriagada (V0rt3x_S0urc3)
# =============================================================================

# --- BANNER DE INICIO ---
echo -e "\033[1;36m╔════════════════════════════════════════════════════╗"
echo -e "║     KALI PORTABLE FULL - PENTESTING EDITION      ║"
echo -e "╠════════════════════════════════════════════════════╣"
echo -e "║  Creado por: Diego Arriagada                 ║"
echo -e "║  Alias:      V0rt3x_S0urc3                     ║"
echo -e "║                                                ║"
echo -e "║  \033[1;34mGitHub:   github.com/diegoarriagadazamora\033[1;36m  ║"
echo -e "║  \033[1;34mLinkedIn: linkedin.com/in/diegoarriagadazamora\033[1;36m║"
echo -e "╚════════════════════════════════════════════════════╝\033[0m"
echo ""

# --- VARIABLES DE ENTORNO (Usan el directorio actual para ser infalibles) ---
IMAGE="kali-pentest-full"
DATA_DIR="${PWD}/data"
SCRIPTS_DIR="${PWD}/scripts"
MODE="${1:-normal}"  # normal | wpa2

# --- CREAR ESTRUCTURA DE DIRECTORIOS SI NO EXISTE ---
mkdir -p "${DATA_DIR}"/{scripts,wordlists,loot,reports,tools,handshakes,pcaps}
mkdir -p "${SCRIPTS_DIR}"

# --- PERMITIR INTERFAZ GRÁFICA (X11) ---
xhost +local:docker 2>/dev/null || xhost +local: >/dev/null 2>&1

# --- DETECTAR GPU NVIDIA ---
if command -v nvidia-smi &> /dev/null && docker run --rm --gpus all nvidia/cuda:12.3.1-base-ubuntu22.04 nvidia-smi &> /dev/null; then
    GPU_FLAG="--gpus all"
    echo -e "\033[1;32m🚀 GPU NVIDIA detectada: Hashcat con aceleración GPU ACTIVADA\033[0m"
else
    GPU_FLAG=""
    echo -e "\033[1;33m💻 Sin GPU detectada: Hashcat usará CPU (más lento)\033[0m"
fi

# --- CONSTRUIR COMANDO DOCKER ---
CMD_BASE="docker run --rm -it --network host --cap-add NET_RAW --cap-add NET_ADMIN ${GPU_FLAG} -e DISPLAY=${DISPLAY} -v /tmp/.X11-unix:/tmp/.X11-unix -v ${DATA_DIR}:/root/pentest -v ${SCRIPTS_DIR}:/root/pentest/scripts:ro -v /usr/share/wordlists:/host-wordlists:ro"


# --- EJECUTAR SEGÚN EL MODO ---
if [ "$MODE" == "wpa2" ]; then
    echo -e "\n\033[1;31m⚠️  Modo WPA2: habilitando --privileged para hcxdumptool\033[0m"
    echo -e "\033[1;31m⚠️  Solo úsalo con un adaptador WiFi USB compatible.\033[0m\n"
    eval "${CMD_BASE} --privileged ${IMAGE}"
else
    echo -e "\n\033[1;32m✅ Modo normal: herramientas CLI + GUI (Burp, Wireshark)\033[0m\n"
    eval "${CMD_BASE} ${IMAGE}"
fi

# --- LIMPIEZA AL SALIR ---
xhost -local:docker 2>/dev/null || true
