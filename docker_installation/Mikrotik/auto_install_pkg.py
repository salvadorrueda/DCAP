#!/usr/bin/env python3
import os
import sys
import subprocess
import urllib.request
import zipfile
import shutil


def download_and_install_pkg():
    print("--- Mikrotik Container Package Auto-Installer ---")
    
    # Paràmetres per defecte o entrada de l'usuari
    ip = input("Entra la IP del Mikrotik (ex: 192.168.1.186): ")
    versio = input("Entra la versió de RouterOS (ex: 7.20.7): ")
    arch = "x86" # Per defecte segons la petició
    
    zip_filename = f"all_packages-{arch}-{versio}.zip"
    url = f"https://download.mikrotik.com/routeros/{versio}/{zip_filename}"
    pkg_name = f"container-{versio}.npk"
    
    print(f"\n1. Descarregant {zip_filename}...")
    try:
        urllib.request.urlretrieve(url, zip_filename)
    except Exception as e:
        print(f"Error descarregant el fitxer: {e}")
        return

    print(f"2. Extraient {pkg_name}...")
    try:
        with zipfile.ZipFile(zip_filename, 'r') as zip_ref:
            # Busquem el fitxer que contingui 'container' ja que el nom exacte pot variar lleugerament
            container_file = [f for f in zip_ref.namelist() if 'container' in f and f.endswith('.npk')]
            if not container_file:
                print("No s'ha trobat el paquet 'container' dins del ZIP.")
                return
            
            pkg_to_extract = container_file[0]
            zip_ref.extract(pkg_to_extract, ".")
            # El rename és per normalitzar si cal
            os.rename(pkg_to_extract, "container.npk")
    except Exception as e:
        print(f"Error extraient el paquet: {e}")
        return

    print(f"3. Pujant container.npk a admin@{ip}...")
    try:
        # Fem servir SCP (requereix que l'usuari tingui claus SSH o entri password)
        subprocess.run(["scp", "container.npk", f"admin@{ip}:/"], check=True)
    except subprocess.CalledProcessError:
        print("Error en la pujada via SCP.")
        return

    print(f"4. Demanant reinici del router...")
    try:
        # Comandament per reiniciar
        subprocess.run(["ssh", f"admin@{ip}", "/system reboot"], input=b"y\n")
        print("\nEl router s'està reiniciant. El paquet s'instal·larà automàticament.")
        print("Recorda que després hauràs d'activar el mode container manualment:")
        print(f"  ssh admin@{ip} \"/system device-mode update container=yes\"")
        print("I fer el cold boot/reset físic dins dels 5 minuts següents.")
    except Exception as e:
        print(f"Error en connectar per SSH: {e}")

    # Neteja
    if os.path.exists(zip_filename): os.remove(zip_filename)
    if os.path.exists("container.npk"): os.remove("container.npk")

if __name__ == "__main__":
    download_and_install_pkg()
