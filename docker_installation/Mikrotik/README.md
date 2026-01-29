# Script per habilitar Docker en Mikrotik RouterOS (v7.7+)

Aquest script configura l'entorn bàsic per poder executar contenidors Docker.

## Passos previs

1. **Arquitectura**: Assegura't que el teu Mikrotik té arquitectura ARM, ARM64 o x86 i corre RouterOS v7.
2. **Espai**: Docker requereix espai de disc (millor si tens un USB o disc extern muntat).

## Com fer-ho servir

1. Puja el fitxer `enable_docker.rsc` al teu Mikrotik.
2. Executa'l des del terminal: `/import enable_docker.rsc`
3. **IMPORTANT**: Per seguretat, Mikrotik demana una confirmació física o un reinici especial per activar el "container mode":
   - Després d'executar l'ordre d'activació (inclosa al script), hauràs de prémer el botó "Reset" del router o apagar i encendre en un interval de temps si no hi ha botó.
   - Revisa el log: `/log print` per veure les instruccions exactes que dóna el router.

## Configuració inclosa
- Bridge: `docker-bridge` (IP 172.17.0.1/24)
- VETH: `veth1` (IP 172.17.0.2/24)
- Registry: Habilita Docker Hub (`https://registry-1.docker.io`)
