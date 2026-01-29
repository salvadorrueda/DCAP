# Script per habilitar Docker en Mikrotik (RouterOS v7)
# Creat per Antigravity

:log info "Iniciant configuració de Docker..."

# Verificació de si el paquet container està instal·lat
:if ([:len [/system package find name="container"]] = 0) do={
    :log error "ERROR: El paquet 'container' no està instal·lat. Si us plau, instal·la'l primer."
    :error "Aturant script: Cal instal·lar el paquet 'container'."
}

# 1. Crear el Bridge per als contenidors
:if ([:len [/interface bridge find name=docker-bridge]] = 0) do={
    /interface bridge add name=docker-bridge comment="Bridge per a contenidors Docker"
}
/ip address add address=172.17.0.1/24 interface=docker-bridge network=172.17.0.0

# 2. Configurar NAT per a la sortida a Internet
/ip firewall nat add action=masquerade chain=srcnat src-address=172.17.0.0/24 comment="NAT per a contenidors Docker"

# 3. Crear interfície VETH (Virtual Ethernet)
/interface veth add name=veth1 address=172.17.0.2/24 gateway=172.17.0.1

# 4. Afegir VETH al bridge
/interface bridge port add bridge=docker-bridge interface=veth1

# 5. Configurar el registre de Docker (Docker Hub)
/container config set registry-url=https://registry-1.docker.io tmpdir=disk1/pull

:log info "Configuració base de Docker finalitzada."
