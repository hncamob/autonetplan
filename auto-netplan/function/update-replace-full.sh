#!/bin/bash

# Declaracion de variables
program_files="/usr/local/sbin/auto-netplan"
# Se usa el idioma ya usado en versiones previas
language=$(cat $program_files/program-files/language.lg)
#   Nueva version  (new version)
nwvsn="/usr/local/sbin/auto-netplan/temp"

# Contenido a reemplazar
#   version [done]
#   Todos los ficheros .sh
#   Fichero de configuracion [done]
#   Fichero .help [done]
#   Fichero .man [done]

# Comprobar existencia de fichero de version
if [[ -f "$nwvsn/program-files/version" ]]; then
    if [[ $language == "ESP" ]]; then
        echo "[#] Actualizando fichero de version..."
    elif [[ $language == "ENG" ]]; then
        echo "[#] Updating version file..."
    else
        echo "[#]Updating version file..." 
    fi
    # Eliminar fichero local
    sudo rm "$program_files/program-files/version"
    # Copiar fichero descargado a ruta indicada
    sudo cp "$nwvsn/program-files/version" "/usr/local/sbin/auto-netplan/program-files/version"
fi

# Comprobar fichero de configuracion
if [[ -f "$nwvsn/auneconf/autonetplan.conf" ]]; then
    if [[ $language == "ESP" ]]; then
        echo "[#] Actualizando fichero de configuracion..."
    elif [[ $language == "ENG" ]]; then
        echo "[#] Updating configuration file..."
    else
        echo "[#] Updating configuration file..."
    fi
    # Eliminar fichero de configuracion local
    sudo rm "/etc/autonetplan/autonetplan.conf"
    # Copiar fichero descargado a ruta indicada
    sudo cp "$nwvsn/auneconf/autonetplan.conf" "/etc/autonetplan/autonetplan.conf"
fi

# Comprobar fichero de manual
if [[ -f "$nwvsn/program-files/autonetplan.man" ]]; then
    if [[ $language == "ESP" ]]; then
        echo "[#] Actualizando fichero de manual..."
    elif [[ $language == "ENG" ]]; then
        echo "[#] Updating manual file..."
    else
        echo "[#] Updating manual file..."
    fi
    # Eliminar fichero manual local
    sudo rm "$program_files/program-files/autonetplan.man"
    # Copiar fichero descargado a ruta indicada
    sudo cp "$nwvsn/program-files/autonetplan.man" "$program_files/program-files/autonetplan.man"
fi

# Comprobar fichero de mhelp
if [[ -f "$nwvsn/program-files/autonetplan.help" ]]; then
    if [[ $language == "ESP" ]]; then
        echo "[#] Actualizando fichero de ayuda..."
    elif [[ $language == "ENG" ]]; then
        echo "[#] Updating help file..."
    else
        echo "[#] Updating help file..."
    fi
    # Eliminar fichero manual local
    sudo rm "$program_files/program-files/autonetplan.help"
    # Copiar fichero descargado a ruta indicada
    sudo cp "$nwvsn/program-files/autonetplan.help" "$program_files/program-files/autonetplan.help"
fi

# Finalizacion de actualizacion
if [[ $language == "ESP" ]]; then
    echo -e "[\e[32m#\e[0m] Actualizacion finalizada correctamente."
elif [[ $language == "ENG" ]]; then
    echo -e "[\e[32m#\e[0m] Update finished correctly."
else
    echo -e "[\e[32m#\e[0m] Update finished correctly."
fi