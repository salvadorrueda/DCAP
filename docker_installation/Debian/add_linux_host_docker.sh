#!/bin/bash

# Script per afegir un servidor Linux remot com a target de Prometheus (DOCKER)
# SAAP - Salvador Rueda

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

# Directori de monitorització Docker
INSTALL_DIR="$HOME/docker_monitoring"
PROM_CONF="$INSTALL_DIR/prometheus.yml"

echo -e "${BLUE}--- Afegir Servidor Linux Remot a la Monitorització (DOCKER) ---${NC}"

# Comprovar si el directori existeix
if [ ! -d "$INSTALL_DIR" ]; then
    echo -e "${RED}Error: No s'ha trobat el directori $INSTALL_DIR.${NC}"
    echo -e "Assegura't que has instal·lat la monitorització amb Docker primer."
    exit 1
fi

# Demanar dades
read -p "IP o Nom del servidor remot: " REMOTE_IP

if [ -z "$REMOTE_IP" ]; then
    echo -e "${RED}Error: La IP o nom és obligatori.${NC}"
    exit 1
fi

echo -e "${GREEN}Afegint el servidor $REMOTE_IP...${NC}"

# 1. Comprovar si el job ja existeix
if grep -q "job_name: 'node_exporter_remote'" "$PROM_CONF"; then
    echo -e "${BLUE}El job 'node_exporter_remote' ja existeix. Afegint target...${NC}"
    # Afegim la IP a la llista de targets
    sed -i "/job_name: 'node_exporter_remote'/,/static_configs/ s/targets: \[/targets: ['$REMOTE_IP:9100', /" "$PROM_CONF"
else
    echo -e "${BLUE}Creant nou job 'node_exporter_remote' a Prometheus...${NC}"
    cat >> "$PROM_CONF" <<EOF

  - job_name: 'node_exporter_remote'
    static_configs:
      - targets: ['$REMOTE_IP:9100']
EOF
fi

# 2. Validar configuració i reiniciat Prometheus a Docker
echo -e "${GREEN}Validant la configuració i reiniciant Prometheus al contenidor...${NC}"

cd "$INSTALL_DIR"

if sudo docker exec prometheus promtool check config /etc/prometheus/prometheus.yml &> /dev/null; then
    echo -e "${GREEN}Configuració vàlida. Reiniciant contenidor Prometheus...${NC}"
    sudo docker compose restart prometheus
else
    echo -e "${RED}Error: La configuració de Prometheus no és vàlida.${NC}"
    echo -e "Si us plau, revisa el fitxer $PROM_CONF manualment."
    exit 1
fi

echo -e "${BLUE}Servidor $REMOTE_IP afegit correctament!${NC}"
echo -e "Recorda que al servidor remot has d'haver instal·lat el node_exporter."
