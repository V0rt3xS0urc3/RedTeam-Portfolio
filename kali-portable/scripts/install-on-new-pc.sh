#!/bin/bash
#===============================================================================
# INSTALL-ON-NEW-PC.SH - Instalador universal de Kali Portable Full
# Construye la imagen Docker y descarga diccionarios automáticamente
# Creado por: Diego Arriagada (V0rt3x_S0urc3)
#===============================================================================

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
BLUE='\033[1;34m'; CYAN='\033[0;36m'; NC='\033[0m'

echo -e "${CYAN}"
echo -e "╔════════════════════════════════════════════════════╗"
echo -e "║  KALI PORTABLE FULL - INSTALADOR UNIVERSAL         ║"
echo -e "╠════════════════════════════════════════════════════╣"
echo -e "║  Autor: Diego Arriagada (V0rt3x_S0urc3)           ║"
echo -e "║  Tiempo estimado: ~30-45 minutos                   ║"
echo -e "╚════════════════════════════════════════════════════╝${NC}"
echo ""

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
DOCKER_DIR="${PROJECT_DIR}/docker"
IMAGE_NAME="kali-pentest-full"

check_command() {
    if command -v "$1" &> /dev/null; then
        echo -e "${GREEN}✓ $1 encontrado${NC}"
        return 0
    else
        echo -e "${RED}✗ $1 no encontrado${NC}"
        return 1
    fi
}

#===============================================================================
# 1. VERIFICAR DOCKER
#===============================================================================
echo -e "${BLUE}[1/4] Verificando Docker...${NC}"
if ! check_command docker; then
    echo -e "${YELLOW}⚠ Instalando Docker automáticamente...${NC}"
    curl -fsSL https://get.docker.com -o /tmp/get-docker.sh
    sudo sh /tmp/get-docker.sh
    sudo usermod -aG docker $USER
    echo -e "${YELLOW}⚠ Cierra sesión y vuelve a entrar para aplicar permisos.${NC}"
    exit 1
fi

if ! docker info &> /dev/null; then
    sudo systemctl start docker 2>/dev/null || sudo service docker start 2>/dev/null
    sleep 3
fi
echo -e "${GREEN}✓ Docker operativo${NC}"

#===============================================================================
# 2. DETECTAR GPU NVIDIA (OPCIONAL)
#===============================================================================
echo -e "${BLUE}[2/4] Detectando GPU NVIDIA...${NC}"
if check_command nvidia-smi &> /dev/null; then
    echo -e "${GREEN}✓ Drivers NVIDIA detectados${NC}"
    if docker run --rm --gpus all nvidia/cuda:12.3.1-base-ubuntu22.04 nvidia-smi &> /dev/null; then
        echo -e "${GREEN}✓ NVIDIA Container Toolkit funcionando${NC}"
    else
        echo -e "${YELLOW}⚠ NVIDIA Container Toolkit no configurado. Hashcat usará CPU.${NC}"
    fi
else
    echo -e "${YELLOW}⚠ Sin GPU NVIDIA detectada. Hashcat usará CPU.${NC}"
fi

#===============================================================================
# 3. CONSTRUIR IMAGEN DOCKER
#===============================================================================
echo -e "${BLUE}[3/4] Construyendo imagen Docker...${NC}"
if docker image inspect "$IMAGE_NAME" &> /dev/null; then
    echo -e "${GREEN}✓ La imagen '$IMAGE_NAME' ya existe.${NC}"
else
    echo -e "${CYAN}[+] Construyendo imagen desde Dockerfile...${NC}"
    echo -e "${YELLOW}⏱ Esto tomará 30-45 minutos dependiendo de tu internet.${NC}"
    
    if docker build -t "$IMAGE_NAME" "$DOCKER_DIR"; then
        echo -e "${GREEN}✓ Imagen construida exitosamente${NC}"
    else
        echo -e "${RED}✗ Error al construir la imagen. Verifica tu conexión a internet.${NC}"
        exit 1
    fi
fi

#===============================================================================
# 4. DESCARGAR DICCIONARIOS Y REGLAS
#===============================================================================
echo -e "${BLUE}[4/4] Configurando diccionarios y reglas...${NC}"

WORDLISTS_DIR="${PROJECT_DIR}/data/wordlists"
RULES_DIR="${PROJECT_DIR}/data/rules"

mkdir -p "$WORDLISTS_DIR" "$RULES_DIR"

# Descargar rockyou.txt si no existe
if [ ! -f "${WORDLISTS_DIR}/rockyou.txt" ] && [ ! -f "${WORDLISTS_DIR}/rockyou.txt.gz" ]; then
    echo -e "${CYAN}[+] Descargando rockyou.txt (~133 MB)...${NC}"
    if wget -q --show-progress -O "${WORDLISTS_DIR}/rockyou.txt.gz" \
        "https://gitlab.com/kalilinux/packages/wordlists/-/raw/kali/master/rockyou.txt.gz" 2>/dev/null; then
        echo -e "${GREEN}✓ rockyou.txt.gz descargado${NC}"
        echo -e "${CYAN}[+] Descomprimiendo...${NC}"
        gunzip -k "${WORDLISTS_DIR}/rockyou.txt.gz"
        echo -e "${GREEN}✓ rockyou.txt listo para usar${NC}"
    else
        echo -e "${YELLOW}⚠ No se pudo descargar rockyou.txt. Hazlo manualmente después.${NC}"
    fi
else
    echo -e "${GREEN}✓ rockyou.txt ya existe${NC}"
fi

# Descargar reglas de Hashcat si no existen
if [ ! -f "${RULES_DIR}/best64.rule" ]; then
    echo -e "${CYAN}[+] Descargando reglas de Hashcat desde la imagen...${NC}"
    docker run --rm -v "${RULES_DIR}:/output" "$IMAGE_NAME" bash -c 'cp -r /usr/share/hashcat/rules/. /output/' 2>/dev/null
    if [ -f "${RULES_DIR}/best64.rule" ]; then
        echo -e "${GREEN}✓ Reglas de Hashcat configuradas${NC}"
    else
        echo -e "${YELLOW}⚠ No se pudieron copiar las reglas.${NC}"
    fi
else
    echo -e "${GREEN}✓ Reglas de Hashcat ya existen${NC}"
fi

# Descargar wordlists para gobuster
if [ ! -f "${WORDLISTS_DIR}/common.txt" ]; then
    echo -e "${CYAN}[+] Descargando wordlists para gobuster...${NC}"
    wget -q "https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Web-Content/common.txt" -O "${WORDLISTS_DIR}/common.txt" 2>/dev/null
    echo -e "${GREEN}✓ Wordlists para gobuster configuradas${NC}"
fi

# Ajustar permisos
sudo chown -R $USER:$USER "${PROJECT_DIR}/data" 2>/dev/null
chmod +x "${PROJECT_DIR}/run-kali.sh" "${PROJECT_DIR}/scripts/"*.sh 2>/dev/null

#===============================================================================
# MENSAJE FINAL
#===============================================================================
echo ""
echo -e "${GREEN}╔════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║        🎉 INSTALACIÓN COMPLETADA 🎉                ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${CYAN}Siguiente paso:${NC}"
echo -e "  cd ${PROJECT_DIR}"
echo -e "  ./run-kali.sh normal"
echo ""
echo -e "${CYAN}¡Bienvenido a Kali Portable Full, ${USER}!${NC}"
echo -e "${CYAN}Creado por V0rt3x_S0urc3 🔐${NC}"
