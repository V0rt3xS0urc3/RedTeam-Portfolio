#!/bin/bash
#===============================================================================
# AUTO-CRACK-WPA2.SH - Versión Lite (Corregida)
# Creado por: Diego Arriagada (V0rt3x_S0urc3)
#===============================================================================

# Colores
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
CYAN='\033[0;36m'; NC='\033[0m'

# Rutas
LOOT_DIR="/root/pentest/loot"
RULES_DIR="/usr/share/hashcat/rules"
WORDLISTS_DIR="/usr/share/wordlists"

# Banner
echo -e "${CYAN}╔════════════════════════════════════╗"
echo -e "║  AUTO-CRACK-WPA2 - Hashcat Tool     ║"
echo -e "║  Creado por: Diego Arriagada        ║"
echo -e "║  Alias: V0rt3x_S0urc3               ║"
echo -e "╚════════════════════════════════════╝${NC}\n"

# Ayuda
if [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]] || [[ -z "$1" ]]; then
    echo -e "${YELLOW}Uso:${NC} $0 <archivo.pcapng o .hc22000> [opciones]"
    echo -e "${CYAN}Opciones:${NC}"
    echo "  -r <regla>      Regla Hashcat (default: best64.rule)"
    echo "  -w <wordlist>   Diccionario (default: custom/basic-nvr.txt)"
    echo "  -c              Forzar modo CPU"
    echo "  -q              Modo rápido (rockyou + best64)"
    echo -e "${YELLOW}Ejemplo:${NC} $0 -q captura.pcapng"
    exit 0
fi

# Variables por defecto
INPUT_FILE="$1"
shift
RULE="best64.rule"
WORDLIST="custom/basic-nvr.txt"
GPU_FLAG="-D 2"

# Parsear opciones restantes
while [[ $# -gt 0 ]]; do
    case $1 in
        -r) RULE="$2"; shift 2 ;;
        -w) WORDLIST="$2"; shift 2 ;;
        -c) GPU_FLAG="-D 1"; shift ;;
        -q) WORDLIST="rockyou.txt"; RULE="best64.rule"; shift ;;
        *) shift ;;
    esac
done

# Verificar archivo de entrada
if [[ ! -f "$INPUT_FILE" ]]; then
    echo -e "${RED}✗ Error: Archivo no encontrado: $INPUT_FILE${NC}"
    exit 1
fi

# Detectar GPU (fallback a CPU si falla)
if [[ "$GPU_FLAG" == "-D 2" ]] && ! hashcat -I 2>/dev/null | grep -q "NVIDIA"; then
    echo -e "${YELLOW}⚠ GPU no detectada, usando CPU${NC}"
    GPU_FLAG="-D 1"
fi

# Convertir si es pcapng
HANDSHAKE="$INPUT_FILE"
if [[ "$INPUT_FILE" == *.pcapng ]] || [[ "$INPUT_FILE" == *.pcap ]]; then
    echo -e "${CYAN}[+] Convirtiendo handshake...${NC}"
    HANDSHAKE="${LOOT_DIR}/$(basename "$INPUT_FILE" .pcapng).hc22000"
    if ! hcxpcapngtool -o "$HANDSHAKE" "$INPUT_FILE" >/dev/null 2>&1; then
        echo -e "${RED}✗ Error en conversión${NC}"
        exit 1
    fi
fi

# Resolver rutas completas
WL_PATH="$WORDLISTS_DIR/$WORDLIST"
[[ ! -f "$WL_PATH" ]] && WL_PATH="$WORDLIST"

RULE_PATH="$RULES_DIR/$RULE"
[[ ! -f "$RULE_PATH" ]] && RULE_PATH="$RULE"

# Construir comando Hashcat
CMD="hashcat -m 22000 $GPU_FLAG -O -w 3 --force"
[[ -f "$RULE_PATH" ]] && CMD="$CMD -r $RULE_PATH"
CMD="$CMD $HANDSHAKE $WL_PATH"

echo -e "${CYAN}[+] Ejecutando:${NC}"
echo "$CMD"
echo ""

# Ejecutar
eval "$CMD"
EXIT_CODE=$?

# Mostrar resultados
POTFILE="${HANDSHAKE%.hc22000}.potfile"
echo ""
if [[ -f "$POTFILE" ]] && [[ -s "$POTFILE" ]]; then
    echo -e "${GREEN}🎉 ¡CONTRASEÑA ENCONTRADA! 🎉${NC}"
    cat "$POTFILE"
else
    echo -e "${YELLOW}⚠ Sin resultados en este intento${NC}"
fi

exit $EXIT_CODE
