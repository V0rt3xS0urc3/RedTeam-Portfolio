#!/bin/bash
#===============================================================================
# SETUP-WIFI.SH - Configuración automática de Modo Monitor
# Creado por: Diego Arriagada (V0rt3x_S0urc3)
#===============================================================================

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
CYAN='\033[0;36m'; NC='\033[0m'

echo -e "${CYAN}╔════════════════════════════════════╗"
echo -e "║  SETUP-WIFI - Monitor Mode Activator  ║"
echo -e "║  Alias: V0rt3x_S0urc3                  ║"
echo -e "╚════════════════════════════════════╝${NC}\n"

# 1. Buscar interfaces inalámbricas
INTERFACES=$(iw dev 2>/dev/null | awk '$1=="Interface"{print $2}')

if [ -z "$INTERFACES" ]; then
    echo -e "${RED}✗ No se encontraron tarjetas WiFi.${NC}"
    echo -e "${YELLOW}⚠ Verifica que conectaste el USB y usaste './run-kali.sh wpa2'.${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Interfaces encontradas: ${NC}$INTERFACES"

# 2. Selección (automática si hay 1, manual si hay más)
IFACE_COUNT=$(echo "$INTERFACES" | wc -l)
if [ "$IFACE_COUNT" -eq 1 ]; then
    TARGET_IFACE="$INTERFACES"
else
    read -p "Escribe el nombre de la interfaz (ej. wlan0): " TARGET_IFACE
fi

# 3. Matar procesos conflictivos
echo -e "${CYAN}[+] Deteniendo servicios conflictivos...${NC}"
airmon-ng check kill >/dev/null 2>&1

# 4. Activar Modo Monitor
echo -e "${CYAN}[+] Activando modo monitor en $TARGET_IFACE...${NC}"
airmon-ng start "$TARGET_IFACE" >/dev/null 2>&1
sleep 2

# 5. Verificar nuevo nombre
NEW_IFACE=$(iw dev 2>/dev/null | awk '/Interface/{print $2}' | grep mon)

if [ -n "$NEW_IFACE" ]; then
    echo -e "${GREEN}🎉 ¡ÉXITO! Modo Monitor activado.${NC}"
    echo -e "${CYAN}Tu nueva interfaz es: ${GREEN}$NEW_IFACE${NC}"
    echo -e "${YELLOW}⚠ Úsala con hcxdumptool o aircrack-ng.${NC}"
else
    echo -e "${RED}✗ Error: No se pudo crear la interfaz de monitor.${NC}"
fi
