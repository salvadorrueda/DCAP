# Script per instal·lar Portainer en Mikrotik (RouterOS v7)
# Creat per Antigravity

:log info "Iniciant instal·lació de Portainer..."

# 1. Configurar interfície VETH per a Portainer
# S'assumeix que el bridge 'docker-bridge' ja existeix (creat per enable_docker.rsc)
/interface veth add name=veth-portainer address=172.17.0.10/24 gateway=172.17.0.1

# 2. Afegir VETH al bridge
/interface bridge port add bridge=docker-bridge interface=veth-portainer

# 3. Detectar el disc disponible i crear directoris
:local diskPrefix ""
:if ([:len [/disk find]] > 0) do={
    :set diskPrefix ([/disk get [pick [/disk find] 0] name] . "/")
    :log info "S'ha detectat disc: $diskPrefix"
} else={
    :log warning "No s'ha detectat cap disc extern. S'utilitzarà l'emmagatzematge intern (no recomanat)."
}

:local portainerData ($diskPrefix . "portainer_data")
:local portainerRoot ($diskPrefix . "portainer-root")

/file make-directory $portainerData
/container mounts add name=portainer_data src=$portainerData dst=/data

# 4. Instal·lar el contenidor de Portainer
# Es recomana utilitzar la versió 'ce' (Community Edition)
/container add remote-image=portainer/portainer-ce:latest name=portainer interface=veth-portainer mounts=portainer_data root-dir=$portainerRoot logging=yes

:log info "Portainer afegit. Recorda iniciar-lo amb: /container start [find name=portainer]"
:log info "Accés via web al port 9443 (HTTPS) a l'IP 172.17.0.10"
