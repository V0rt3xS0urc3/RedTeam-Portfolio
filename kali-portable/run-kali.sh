#!/bin/bash

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
# ------------------------


# =============================================================================
# SCRIPT UNIVERSAL KALI PORTABLE - Detecta GPU automáticamente
# =============================================================================

IMAGE="kali-pentest-full"
DATA_DIR="$HOME/kali-portable/data"
MODE="${1:-normal}"  # normal | wpa2

mkdir -p ${DATA_DIR}/{scripts,wordlists,loot,reports,tools,handshakes,pcaps}

xhost +local:docker 2>/dev/null || xhost +local:

# Detectar GPU NVIDIA
if command -v nvidia-smi &> /dev/null && docker run --rm --gpus all nvidia/cuda:12.3.1-base-ubuntu22.04 nvidia-smi &> /dev/null; then
    GPU_FLAG="--gpus all"
    echo "🚀 GPU NVIDIA detectada: Hashcat con aceleración GPU ACTIVADA"
else
    GPU_FLAG=""
    echo "💻 Sin GPU: Hashcat usará CPU (más lento)"
fi

CMD_BASE="docker run --rm -it \
  --network host \
--cap-add NET_RAW \
  --cap-add NET_ADMIN \
  ${GPU_FLAG} \
  -e DISPLAY=$DISPLAY \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -v ${DATA_DIR}:/root/pentest \
  -v /usr/share/wordlists:/host-wordlists:ro"
  -v ${DATA_DIR}/../scripts:/root/pentest/scripts \


if [ "$MODE" == "wpa2" ]; then
    echo "⚠️  Modo WPA2: habilitando --privileged para hcxdumptool"
    echo "⚠️  Solo úsalo en entornos controlados."
    $CMD_BASE --privileged $IMAGE
else
    echo "✅ Modo normal: herramientas CLI + GUI (Burp, Wireshark)"
    $CMD_BASE $IMAGE
fi

xhost -local:docker 2>/dev/null || true
