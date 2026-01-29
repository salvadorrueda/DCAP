# Script per habilitar Docker en Mikrotik RouterOS (v7.7+)

Aquest script configura l'entorn bàsic per poder executar contenidors Docker.

## Passos previs (Molt Important)

1. **Instal·lació del Paquet `container`**:
   - Ves a la web de Mikrotik i baixa els "Extra packages" per a la teva arquitectura (ex: x86, ARM).
   - Descomprimeix el fitxer i cerca `container-x.y.npk`.
   - Arrossega i deixa anar aquest fitxer a la secció **Files** del teu WinBox.
   - Reinicia el router (`/system reboot`) per instal·lar el paquet.
2. **Habilitar el mode Container**:
   - Un cop reiniciat, obre un Terminal i executa: `/system device-mode update container=yes`.
   - **Confirmació física**: En un interval de 5 minuts, has de fer un "cold boot" (apagar i encendre el router o prémer el botó reset) per confirmar el canvi.

## Com fer-ho servir el script

1. Un cop el paquet estigui instal·lat i el mode habitat, puja el fitxer `enable_docker.rsc`.
2. Executa'l: `/import enable_docker.rsc`

## Configuració inclosa
- Bridge: `docker-bridge` (IP 172.17.0.1/24)
- VETH: `veth1` (IP 172.17.0.2/24)
- Registry: Habilita Docker Hub (`https://registry-1.docker.io`)
