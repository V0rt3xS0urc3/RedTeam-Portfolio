#!/bin/bash
#===============================================================================
# AUTO-CRACK-WPA2.SH - Versión Definitiva y Limpia
# Creado por: Diego Arriagada (V0rt3x_S0urc3)
#===============================================================================

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
CYAN='\033[0;36m'; NC='\033[0m'

# Rutas absolutas en el contenedor
LOOT_DIR="/root/pentest/loot"
RULES_DIR="/root/pentest/rules"
WORDLISTS_DIR="/root/pentest/wordlists"

echo -e "${CYAN}╔════════════════════════════════════╗"
echo -e "║  AUTO-CRACK-WPA2 - Hashcat Tool     ║"
echo -e "║  Creado por: Diego Arriagada        ║"
echo -e "║  Alias: V0rt3x_S0urc3               ║"
echo -e "╚════════════════════════════════════╝${NC}\n"

# Variables por defecto (Usamos rockyou.txt como estándar)
INPUT_FILE=""
RULE="best64.rule"
WORDLIST="rockyou.txt"
GPU_FLAG="-D 2"

# Parseo robusto de argumentos
while [[ $# -gt 0 ]]; do
    case $1 in
        -r) RULE="$2"; shift 2 ;;
        -w) WORDLIST="$2"; shift 2 ;;
        -c) GPU_FLAG="-D 1"; shift ;;
        -q) WORDLIST="rockyou.txt"; RULE="best64.rule"; shift ;;
        -*) echo -e "${RED}✗ Opción desconocida: $1${NC}"; exit 1 ;;
        *) 
            if [ -z "$INPUT_FILE" ]; then
                INPUT_FILE="$1"
            fi
            shift 
            ;;
    esac
done

# Validar archivo de entrada
if [ -z "$INPUT_FILE" ]; then
    echo -e "${RED}✗ Error: Debes especificar un archivo .pcapng o .hc22000${NC}"
    echo -e "${YELLOW}Uso: $0 [-q] <archivo>${NC}"
    exit 1
fi

if [[ ! -f "$INPUT_FILE" ]]; then
    echo -e "${RED}✗ Error: Archivo no encontrado: $INPUT_FILE${NC}"
    exit 1
fi

# Detectar GPU
if [[ "$GPU_FLAG" == "-D 2" ]] && ! hashcat -I 2>/dev/null | grep -q "NVIDIA"; then
    echo -e "${YELLOW}⚠ GPU no detectada, usando CPU${NC}"
    GPU_FLAG="-D 1"
else
    echo -e "${GREEN}✓ GPU NVIDIA detectada${NC}"
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

# Resolver rutas (Lógica a prueba de balas con descompresión automática)
WL_PATH="$WORDLISTS_DIR/$WORDLIST"

# Si no existe pero existe la versión .gz, descomprimir
if [[ ! -f "$WL_PATH" ]] && [[ -f "${WL_PATH}.gz" ]]; then
    echo -e "${CYAN}[+] Descomprimiendo $WORDLIST.gz...${NC}"
    gunzip -k "${WL_PATH}.gz"
fi

# Buscar en otras ubicaciones si aún no existe
[[ ! -f "$WL_PATH" ]] && WL_PATH="/usr/share/wordlists/$WORDLIST"
[[ ! -f "$WL_PATH" ]] && [[ -f "/usr/share/wordlists/${WORDLIST}.gz" ]] && {
    echo -e "${CYAN}[+] Descomprimiendo /usr/share/wordlists/$WORDLIST.gz...${NC}"
    gunzip -k "/usr/share/wordlists/${WORDLIST}.gz"
    WL_PATH="/usr/share/wordlists/$WORDLIST"
}
[[ ! -f "$WL_PATH" ]] && WL_PATH="$WORDLIST"

# Lo mismo para las reglas
RULE_PATH="$RULES_DIR/$RULE"
[[ ! -f "$RULE_PATH" ]] && RULE_PATH="/usr/share/hashcat/rules/$RULE"
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
