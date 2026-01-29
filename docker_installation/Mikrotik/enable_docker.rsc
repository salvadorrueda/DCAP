# Script per habilitar Docker en Mikrotik (RouterOS v7)
# Creat per Antigravity

:log info "Iniciant configuració de Docker..."

# 1. Crear el Bridge per als contenidors
/interface bridge add name=docker-bridge comment="Bridge per a contenidors Docker"
/ip address add address=172.17.0.1/24 interface=docker-bridge network=172.17.0.0

# 2. Configurar NAT per a la sortida a Internet
/ip firewall nat add action=masquerade chain=srcnat src-address=172.17.0.0/24 comment="NAT per a contenidors Docker"

# 3. Crear interfície VETH (Virtual Ethernet)
/interface veth add name=veth1 address=172.17.0.2/24 gateway=172.17.0.1

# 4. Afegir VETH al bridge
/interface bridge port add bridge=docker-bridge interface=veth1

# 5. Configurar el registre de Docker (Docker Hub)
/container config set registry-url=https://registry-1.docker.io tmpdir=disk1/pull

# 6. Intentar activar el mode contenidor
# NOTA: Això requerirà confirmació física (botó reset o power cycle)
:log warning "S'HA D'ACTIVAR EL MODE CONTENIDOR MANUALMENT SI ÉS LA PRIMERA VEGADA"
/system device-mode update container=yes

:log info "Configuració base de Docker finalitzada. Revisa el log per a la confirmació del device-mode."
