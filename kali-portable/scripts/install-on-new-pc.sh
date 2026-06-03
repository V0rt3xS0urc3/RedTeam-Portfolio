#!/bin/bash
#===============================================================================
# INSTALL-ON-NEW-PC.SH - Instalador universal de Kali Portable Full
# Construye automáticamente la imagen Docker con todas las herramientas
# Creado por: Diego Arriagada (V0rt3x_S0urc3)
#===============================================================================

# Colores
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
BLUE='\033[1;34m'; CYAN='\033[0;36m'; NC='\033[0m'

# Banner
echo -e "${CYAN}"
echo -e "╔════════════════════════════════════════════════════╗"
echo -e "║  KALI PORTABLE FULL - INSTALADOR UNIVERSAL         ║"
echo -e "╠════════════════════════════════════════════════════╣"
echo -e "║  Autor: Diego Arriagada (V0rt3x_S0urc3)           ║"
echo -e "║  Tiempo estimado: ~30-45 minutos                   ║"
echo -e "╚════════════════════════════════════════════════════╝${NC}"
echo ""

# Detectar ubicación del script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
DOCKERFILE_DIR="${PROJECT_DIR}/docker"
IMAGE_NAME="kali-pentest-full"

#===============================================================================
# FUNCIÓN DE VERIFICACIÓN
#===============================================================================
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
# 1. VERIFICAR SISTEMA OPERATIVO
#===============================================================================
echo -e "${BLUE}[1/5] Verificando sistema operativo...${NC}"
if [[ "$OSTYPE" != "linux-gnu"* ]]; then
    echo -e "${YELLOW}⚠ Este instalador está optimizado para Linux.${NC}"
    echo -e "En Windows usa WSL2 y en macOS sigue los pasos del README.md"
    read -p "¿Deseas continuar de todas formas? [s/N]: " -n 1 -r
    echo
    [[ ! $REPLY =~ ^[Ss]$ ]] && exit 1
else
    echo -e "${GREEN}✓ Linux detectado${NC}"
fi

#===============================================================================
# 2. VERIFICAR/INSTALAR DOCKER
#===============================================================================
echo -e "${BLUE}[2/5] Verificando Docker...${NC}"
if check_command docker; then
    if ! docker info &> /dev/null; then
        echo -e "${YELLOW}⚠ Docker no está corriendo. Iniciando...${NC}"
        sudo systemctl start docker 2>/dev/null || sudo service docker start 2>/dev/null
        sleep 3
        if ! docker info &> /dev/null; then
            echo -e "${RED}✗ No se pudo iniciar Docker.${NC}"
            echo -e "Instala Docker manualmente: https://docs.docker.com/engine/install/"
            exit 1
        fi
    fi
    echo -e "${GREEN}✓ Docker operativo${NC}"
else
    echo -e "${YELLOW}⚠ Docker no está instalado.${NC}"
    read -p "¿Instalar Docker automáticamente? [S/n]: " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Nn]$ ]]; then
        echo -e "${RED}✗ Instalación cancelada.${NC}"
        exit 1
    fi
    
    echo -e "${CYAN}[+] Descargando script oficial de Docker...${NC}"
    curl -fsSL https://get.docker.com -o /tmp/get-docker.sh
    sudo sh /tmp/get-docker.sh
    rm /tmp/get-docker.sh
    
    sudo usermod -aG docker $USER 2>/dev/null
    echo -e "${YELLOW}⚠ Cierra sesión y vuelve a entrar para aplicar permisos de Docker.${NC}"
    read -p "Presiona Enter cuando hayas vuelto a iniciar sesión..."
fi

#===============================================================================
# 3. DETECTAR Y CONFIGURAR GPU (OPCIONAL)
#===============================================================================
echo -e "${BLUE}[3/5] Detectando GPU NVIDIA...${NC}"
GPU_AVAILABLE=false

if check_command nvidia-smi &> /dev/null; then
    echo -e "${GREEN}✓ Drivers NVIDIA detectados${NC}"
    nvidia-smi --query-gpu=name,driver_version --format=csv,noheader 2>/dev/null
    
    if docker run --rm --gpus all nvidia/cuda:12.3.1-base-ubuntu22.04 nvidia-smi &> /dev/null; then
        echo -e "${GREEN}✓ NVIDIA Container Toolkit funcionando${NC}"
        GPU_AVAILABLE=true
    else
        echo -e "${YELLOW}⚠ NVIDIA Container Toolkit no configurado.${NC}"
        read -p "¿Instalar toolkit para aceleración GPU? [S/n]: " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Nn]$ ]]; then
            echo -e "${CYAN}[+] Instalando NVIDIA Container Toolkit...${NC}"
            curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | \
                sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg
            curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
                sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
                sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
            sudo apt update
            sudo apt install -y nvidia-container-toolkit
            sudo nvidia-ctk runtime configure --runtime=docker
            sudo systemctl restart docker
            GPU_AVAILABLE=true
            echo -e "${GREEN}✓ Toolkit instalado y Docker reiniciado${NC}"
        fi
    fi
else
    echo -e "${YELLOW}⚠ Sin GPU NVIDIA. Hashcat usará CPU.${NC}"
    echo -e "Si quieres aceleración GPU, instala los drivers propietarios de NVIDIA."
fi

#===============================================================================
# 4. CONSTRUIR IMAGEN DOCKER
#===============================================================================
echo -e "${BLUE}[4/5] Construyendo imagen Docker...${NC}"

if docker image inspect "$IMAGE_NAME" &> /dev/null; then
    echo -e "${GREEN}✓ Imagen '$IMAGE_NAME' ya existe${NC}"
    read -p "¿Reconstruir desde cero? [s/N]: " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Ss]$ ]]; then
        echo -e "${CYAN}[+] Usando imagen existente${NC}"
    else
        echo -e "${CYAN}[+] Eliminando imagen anterior...${NC}"
        docker rmi "$IMAGE_NAME" 2>/dev/null
    fi
fi

if ! docker image inspect "$IMAGE_NAME" &> /dev/null; then
    if [ ! -f "${DOCKERFILE_DIR}/Dockerfile" ]; then
        echo -e "${RED}✗ Dockerfile no encontrado en: ${DOCKERFILE_DIR}/Dockerfile${NC}"
        exit 1
    fi
    
    echo -e "${CYAN}[+] Construyendo imagen desde Dockerfile...${NC}"
    echo -e "${YELLOW}⏱ Esto tomará 30-45 minutos dependiendo de tu conexión a internet${NC}"
    echo -e "${YELLOW}   Se descargarán e instalarán ~100 herramientas de pentesting${NC}"
    echo ""
    
    if docker build -t "$IMAGE_NAME" "${DOCKERFILE_DIR}"; then
        echo -e "${GREEN}✓ Imagen construida exitosamente${NC}"
    else
        echo -e "${RED}✗ Error al construir la imagen${NC}"
        echo -e "Verifica tu conexión a internet e intenta nuevamente"
        exit 1
    fi
fi

#===============================================================================
# 5. CONFIGURAR ESTRUCTURA Y PERMISOS
#===============================================================================
echo -e "${BLUE}[5/5] Configurando estructura de proyecto...${NC}"

# Crear carpetas de persistencia
mkdir -p "${PROJECT_DIR}/data"/{scripts,wordlists,loot,reports,tools,handshakes,pcaps,vpn}
echo -e "${GREEN}✓ Carpetas de persistencia creadas${NC}"

# Dar permisos de ejecución a los scripts
chmod +x "${PROJECT_DIR}/run-kali.sh" 2>/dev/null
chmod +x "${PROJECT_DIR}/scripts/"*.sh 2>/dev/null
echo -e "${GREEN}✓ Permisos de ejecución configurados${NC}"

# Ajustar permisos del directorio data
sudo chown -R $USER:$USER "${PROJECT_DIR}/data" 2>/dev/null
echo -e "${GREEN}✓ Permisos de carpetas ajustados${NC}"

#===============================================================================
# PRUEBA FINAL
#===============================================================================
echo -e "${BLUE}[✓] Ejecutando prueba final...${NC}"

TEST_OUTPUT=$(docker run --rm --entrypoint "/bin/bash" "$IMAGE_NAME" -c "echo 'CONTAINER_OK'; hashcat -I 2>&1 | grep -i 'Platform' | head -1" 2>&1)

if echo "$TEST_OUTPUT" | grep -q "CONTAINER_OK"; then
    echo -e "${GREEN}✓ Contenedor inicia correctamente${NC}"
    
    if echo "$TEST_OUTPUT" | grep -qi "NVIDIA"; then
        echo -e "${GREEN}✓ GPU detectada dentro del contenedor${NC}"
    else
        echo -e "${YELLOW}⚠ GPU no disponible (modo CPU activo)${NC}"
    fi
else
    echo -e "${RED}✗ Error al iniciar el contenedor${NC}"
    echo -e "$TEST_OUTPUT"
    exit 1
fi

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
echo -e "${YELLOW}Modos disponibles:${NC}"
echo -e "  ./run-kali.sh normal    → Pentesting general + GPU"
echo -e "  ./run-kali.sh wpa2      → Auditoría WiFi (requiere USB compatible)"
echo ""
echo -e "${BLUE}Documentación completa:${NC}"
echo -e "  cat ${PROJECT_DIR}/README.md"
echo ""
echo -e "${CYAN}¡Bienvenido a Kali Portable Full, ${USER}!${NC}"
echo -e "${CYAN}Creado por V0rt3x_S0urc3 🔐${NC}"
