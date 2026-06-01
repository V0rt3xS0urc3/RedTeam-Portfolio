#!/bin/bash
#===============================================================================
# INSTALL-ON-NEW-PC.SH - Instalador universal de Kali Portable Full
# Convierte cualquier PC con Docker en tu estación de pentesting en 3 minutos
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
echo -e "║  Tiempo estimado: ~3 minutos                       ║"
echo -e "╚════════════════════════════════════════════════════╝${NC}"
echo ""

# Detectar ubicación del script (para encontrar el .tar relativo)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
TAR_FILE="${PROJECT_DIR}/kali-pentest-full.tar"
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
echo -e "${BLUE}[1/6] Verificando sistema operativo...${NC}"
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
echo -e "${BLUE}[2/6] Verificando Docker...${NC}"
if check_command docker; then
    # Verificar que el servicio esté corriendo
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
    
    # Agregar usuario actual al grupo docker (evita usar sudo)
    sudo usermod -aG docker $USER 2>/dev/null
    echo -e "${YELLOW}⚠ Cierra sesión y vuelve a entrar para aplicar permisos de Docker.${NC}"
    read -p "Presiona Enter cuando hayas vuelto a iniciar sesión..."
fi

#===============================================================================
# 3. DETECTAR Y CONFIGURAR GPU (OPCIONAL)
#===============================================================================
echo -e "${BLUE}[3/6] Detectando GPU NVIDIA...${NC}"
GPU_AVAILABLE=false

if check_command nvidia-smi &> /dev/null; then
    echo -e "${GREEN}✓ Drivers NVIDIA detectados${NC}"
    nvidia-smi --query-gpu=name,driver_version --format=csv,noheader 2>/dev/null
    
    # Verificar NVIDIA Container Toolkit
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
# 4. CARGAR IMAGEN DOCKER
#===============================================================================
echo -e "${BLUE}[4/6] Cargando imagen Docker...${NC}"

# Verificar si la imagen ya está cargada
if docker image inspect "$IMAGE_NAME" &> /dev/null; then
    echo -e "${GREEN}✓ Imagen '$IMAGE_NAME' ya está cargada${NC}"
else
    # Buscar el archivo .tar
    if [ ! -f "$TAR_FILE" ]; then
        # Buscar en subcarpeta releases/
        if [ -f "${PROJECT_DIR}/releases/kali-pentest-full.tar" ]; then
            TAR_FILE="${PROJECT_DIR}/releases/kali-pentest-full.tar"
        else
            echo -e "${RED}✗ Archivo kali-pentest-full.tar no encontrado${NC}"
            echo -e "Ubicación esperada: $TAR_FILE"
            echo -e ""
            echo -e "${YELLOW}Opciones:${NC}"
            echo -e "1. Descarga el Release desde GitHub:"
            echo -e "   https://github.com/diegoarriagadazamora/redteam-portfolio/releases"
            echo -e "2. Colócalo en la raíz del proyecto como: kali-pentest-full.tar"
            exit 1
        fi
    fi
    
    echo -e "${CYAN}[+] Cargando imagen desde: $(basename $TAR_FILE)${NC}"
    echo -e "Esto puede tomar 1-3 minutos dependiendo de tu disco..."
    
    if docker load -i "$TAR_FILE"; then
        echo -e "${GREEN}✓ Imagen cargada exitosamente${NC}"
    else
        echo -e "${RED}✗ Error al cargar la imagen. Verifica que el .tar no esté corrupto.${NC}"
        exit 1
    fi
fi

#===============================================================================
# 5. CONFIGURAR ESTRUCTURA Y PERMISOS
#===============================================================================
echo -e "${BLUE}[5/6] Configurando estructura de proyecto...${NC}"

# Crear carpetas de persistencia
mkdir -p "${PROJECT_DIR}/data"/{scripts,wordlists,loot,reports,tools,handshakes,pcaps}
echo -e "${GREEN}✓ Carpetas de persistencia creadas${NC}"

# Dar permisos de ejecución a los scripts
chmod +x "${PROJECT_DIR}/run-kali.sh" 2>/dev/null
chmod +x "${PROJECT_DIR}/scripts/"*.sh 2>/dev/null
echo -e "${GREEN}✓ Permisos de ejecución configurados${NC}"

# Ajustar permisos del directorio data (evita problemas de Docker con root)
sudo chown -R $USER:$USER "${PROJECT_DIR}/data" 2>/dev/null
echo -e "${GREEN}✓ Permisos de carpetas ajustados${NC}"

#===============================================================================
# 6. PRUEBA FINAL
#===============================================================================
echo -e "${BLUE}[6/6] Ejecutando prueba final...${NC}"

# Test rápido: verificar que el contenedor inicia
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
