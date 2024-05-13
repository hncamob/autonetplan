#!/bin/bash

# Programa por github.com/Nisamov
#Copyright [2024] [Andres Abadias]
#
#Licensed under the Apache License, Version 2.0 (the "License");
#you may not use this file except in compliance with the License.
#You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
#Unless required by applicable law or agreed to in writing, software
#distributed under the License is distributed on an "AS IS" BASIS,
#WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#See the License for the specific language governing permissions and
#limitations under the License.

#Programa instalacion servicio autonetplan
# Programa listo para funcionamiento, posteriormente, correccion y agregacion de mejoras

# Ruta del directorio donde se encuentra el script de instalación
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
# Ruta instalacion super usuario
INSTALL_DIR="/usr/local/sbin"
# Ruta ficheros programa super usuario
PROGRAM_FILES="/usr/local/sbin/auto-netplan"
# Ruta netplan
NETWORK="/etc/netplan/"
# Ruta fichero de configuracion guardar dentro de /etc/autonetplan/autonetplan.conf
CONFIG_FILES="/etc"

# Limpiar consola para mejor lectura
clear

# Preguntar sobre el idioma a usar, segun eso, los ficheros se redistribuiran unicamente en el idioma establecido
# Unicamente van a estar disponibles dos idiomas, el ingles y el español (idioma origen)
# Los comentarios no van a ser traducidos, unicamente los mensajes de salida, ahorrando tiempo en la ejecucion de codigo y liberando peso innecesario (para algo estan los traductores)
while true; do
    # No se continuara hasta que se seleccione un lenguaje
    read -p "[AutoNetplan]: Select your language / Seleccione su idioma [eng/esp]: " language

    if [[ $language == "esp" ]]; then
        echo "[#] Se ha seleccionado el idioma Español"
        break
    elif [[ $language == "eng" ]]; then
        echo "[#] You've selected English language"
        break
    else
        echo "[#] Invalid language / Idioma inválido"
    fi
done

# Creacion e instalacion rutas y ficheros del programa
while [[ ! -d $PROGRAM_FILES ]]; do
   # Creacion directorio $PROGRAM_FILES
    sudo mkdir -p $PROGRAM_FILES
    # Si el directorio existe
    if [[ -d $PROGRAM_FILES ]]; then
         # Mensaje instalacion correcta
        if [[ $language == "esp" ]]; then
            echo "[#] Se ha creado la ruta $PROGRAM_FILES exitosamente"
        else
            echo “[#] Path $PROGRAM_FILES has been created successfully”.
        fi
   # Si el directorio no existe
    else
        if [[ $language == "esp" ]]; then
            echo -e "[\e[31m#\e[0m] No se ha clonado $PROGRAM_FILES correctamente, intentando de nuevo..."
            # Espera 1 segundo antes de intentar de nuevo
            sleep 1
        else
            echo -e “[31m] Failed to clone $PROGRAM_FILES successfully, trying again...”
            sleep 1
        fi
    fi
done

# Instalacion de ficheros de configuracion
while [[ ! -d $CONFIG_FILES/autonetplan ]]; do
    # Creacion de ruta
    sudo mkdir "$CONFIG_FILES/autonetplan"
    # Clonacion y renombramiento - copiar todo el contenido a la ruta de fichero de configuracion
    sudo cp -r $SCRIPT_DIR/auneconf/* "$CONFIG_FILES/autonetplan"

    if [[ -d "$CONFIG_FILES/autonetplan" ]]; then
        # Mensaje instalacion correcta
        echo "[#] Se ha creado la ruta $CONFIG_FILES/autonetplan exitosamente"
    else
        echo -e "[\e[31m#\e[0m] No se ha clonado $CONFIG_FILES correctamente, intentando de nuevo..."
        # Espera 1 segundo antes de intentar de nuevo
        sleep 1
    fi
done

# Verificar si el archivo principal existe en la ubicación correcta con el nombre correcto
if [[ -f "$INSTALL_DIR/autonetplan" ]]; then
    # Si el archivo existe, mostrar un mensaje indicando que ya está presente
    echo "[#] El script principal ya existe en $INSTALL_DIR/autonetplan"
else
    while [[ ! -f "$INSTALL_DIR/autonetplan" ]]; do
        echo -e "[\e[31m#\e[0m] El fichero autonetplan no existe, creando..."
        # Si el archivo no existe, intentar copiarlo y renombrarlo
        sudo cp "$SCRIPT_DIR/auto-netplan/autonetplan.sh" "$INSTALL_DIR/autonetplan"
        # Verificar si la copia se realizó correctamente
        if [[ -f "$INSTALL_DIR/autonetplan" ]]; then
            # Mensaje de copia exitosa
            echo "[#] El script principal se ha copiado exitosamente a $INSTALL_DIR/autonetplan"
            # Dar permisos de ejecución al script principal
            sudo chmod +x "$INSTALL_DIR/autonetplan"
            # Mensaje tras otorgar correctamente los permisos
            echo "[#] Permisos necesarios otorgados correctamente"
        else
            # Mensaje si la copia no se realizó correctamente
            echo -e "[\e[31m#\e[0m] No se ha copiado el script principal correctamente, intentando de nuevo..."
            # Espera 1 segundo antes de intentar de nuevo
            sleep 1
        fi
    done
fi

# Copiar ficheros ejemplares en la ruta $PROGRAM_FILES
# Clonacion de contenido /program-files/ dentro de ruta $PROGRAM_FILES de forma recursiva
sudo cp -r "$SCRIPT_DIR/program-files" "$PROGRAM_FILES"
# Verificar si la copia se realizó correctamente
if [[ -d "$PROGRAM_FILES/program-files/" ]]; then
    # Mensaje de copia exitosa
    echo "[#] Se ha copiado exitosamente $SCRIPT_DIR/program-files/* en $PROGRAM_FILES"
else
    # Mensaje si la copia no se realizó correctamente
    echo -e "[\e[31m#\e[0m] No se ha copiado el contenido de $SCRIPT_DIR/program-files/ correctamente, intentando de nuevo..."
    # Espera 1 segundo antes de intentar de nuevo
    sleep 1
fi

# Clonar el fichero de licencia dentro del resto de los ficheros
while [[ ! -f "$PROGRAM_FILES/LICENSE.txt" ]]; do
    # Clonar el archivo de licencia
    sudo cp "$SCRIPT_DIR/LICENSE.txt" "$PROGRAM_FILES"
    # Verificar si la clonación se realizó correctamente
    if [[ -f "$PROGRAM_FILES/LICENSE.txt" ]]; then
        # Mensaje de clonación exitosa de la licencia
        echo "[#] Licencia instalada correctamente 'autonetplan -l' para leerla."
    else
        # Mensaje si la clonación no se realizó correctamente
        echo -e "[\e[31m#\e[0m] No se ha clonado la licencia correctamente, intentando de nuevo..."
        # Espera 1 segundo antes de intentar de nuevo
        sleep 1
    fi
done

# Crear ruta copias de seguridad
while [[ ! -d "$PROGRAM_FILES/autonetplan-backups" ]]; do
    # Clonar el archivo de licencia
    sudo mkdir "$PROGRAM_FILES/autonetplan-backups"
    # Verificacion de creacion
    if [[ -d "$PROGRAM_FILES/autonetplan-backups" ]]; then
        # Mensaje creacion almacenamiento copias de seguridad
        echo "[#] Ruta clonacion copias de seguridad, creada exitosamente"
    else
        # Mensaje si la creacion no se realizó correctamente
        echo -e "[\e[31m#\e[0m] Ha ocurrido un error en la creacion, intentando de nuevo..."
        # Espera 1 segundo antes de intentar de nuevo
        sleep 1
    fi
done

# Verificar si el programa de integridad de dir-file-search existe en la ruta indicada
if [[ -f "$INSTALL_DIR/auto-netplan/program-files/dir-file-search.sh" ]]; then
    # Si el archivo existe, mostrar un mensaje indicando que ya está presente
    echo "[#] El script de integridad ya existe en $INSTALL_DIR/auto-netplan/program-files/dir-file-search.sh"
else
    echo -e "[\e[31m#\e[0m] El fichero dir-file-search.sh no existe, creando..."
    # Si el archivo no existe, intentar copiarlo y renombrarlo
    sudo cp "$SCRIPT_DIR/auto-netplan/dir-file-search.sh" "$INSTALL_DIR/auto-netplan/program-files/dir-file-search.sh"
    if [[ -f "$INSTALL_DIR/autonetplan" ]]; then
        # Indicar existencia de fichero
        echo "[#] El fichero de integridad ha sido creado existosamente"
        # Dar permisos de ejecución al script de integridad
        sudo chmod +x "$INSTALL_DIR/auto-netplan/program-files/dir-file-search.sh"
        # Mensaje tras otorgar correctamente los permisos
        echo "[#] Permisos necesarios otorgados al fichero de integridad correctamente"
    else
        # Mensaje si la copia no se realizó correctamente
        echo -e "[\e[31m#\e[0m] No se ha copiado el script de integridad correctamente, intentando de nuevo..."
        # Espera 1 segundo antes de intentar de nuevo
        sleep 1
    fi
fi

# Otorgar permisos a fichero de configuracion y contenido en su interior
sudo chmod 777 $NETWORK/*

# Creación de ficheros ocultos
while [[ ! -f "$PROGRAM_FILES/.106" ]]; do
    # Clonar el fichero oculto .106
    sudo touch "$PROGRAM_FILES/.106"
    # No serán verificados
done
# Contenido
# Contenido en proceso de edicion

# Funcion pausa
function pause(){
   read -p "$*"
}
#Espacio diferencial de texto
echo ""
# Llamada a funcion previa
pause 'Presione cualquier tecla para continuar...'
# Limpiar consola
clear
# Mensaje muestra de licencia
sudo less LICENSE.txt
# Limpiar consola
clear

# Revision de integridas de ficheros
# Revisar la correcta instalacion de cada uno de los ficheros NECESARIOS para el funcionamiento del programa
function autonetplan-necessary-integrity(){
    # Variables
    var_inter="[autonetplan-integrity]"
    # Inicio de funcion
    echo "[#] Revision de integridad del programa..."
    if [[ -f "/usr/local/sbin/autonetplan" ]]; then
        # Si el fichero existe
        echo -e "[\e[32m#\e[0m] $var_inter El fichero autonetplan se ha instalado correctamente"
        # primera variable de ok
        autone=ok
    else
        # Si no se ha encontrado
        echo -e "[\e[31m#\e[0m] $var_inter El fichero autonetplan no se ha encontrado en el sistema"
        sleep 1
    fi
    if [[ -f $CONFIG_FILES/autonetplan/autonetplan.conf ]]; then
        # Si el fichero existe
        echo -e "[\e[32m#\e[0m] $var_inter El fichero de configuracion se ha instalado correctamente"
        # segunda variable de ok
        autoconf=ok
    else
        # Si no se ha encontrado
        echo -e "[\e[31m#\e[0m] $var_inter El fichero de configuracion no se ha encontrado en el sistema"
        sleep 1
    fi
    if [[ -f $PROGRAM_FILES/program-files/dir-file-search.sh ]]; then
        # Si el fichero existe
        echo -e "[\e[32m#\e[0m] $var_inter El fichero dir-file-search.sh se ha instalado correctamente"
        # tercera variable de ok
        autodirfilesearch=ok
    else
        # Si no se ha encontrado
        echo -e "[\e[31m#\e[0m] $var_inter El fichero dir-file-search.sh no se ha encontrado en el sistema"
        sleep 1
    fi
}

function purge-repo(){
    # Tras la instalacion, el instalador, preguntara si borrar el repositorio clonado para liberar espacio
    read -p "¿Desea borrar el repositorio clonado? [s/n]: " deleteRepos
    if [[ $deleteRepos == "s" || $deleteRepos == "S" ]]; then
    # Verificar si la ruta $SCRIPT_DIR existe
        if [[ -d "$SCRIPT_DIR" ]]; then
            # Si la ruta existe, eliminar de forma recursiva el directorio
            sudo rm -rf "$SCRIPT_DIR"
            # Mensaje de eliminación exitosa
            echo "[#] Se ha eliminado de forma recursiva el repositorio clonado."
        else
            # Si la ruta no existe, mostrar un mensaje indicando que no existe
            echo "[#] La ruta '$SCRIPT_DIR' no existe."
        fi
    else
        echo "El repositorio no se eliminara del sistema"
    fi
}

# Llamada a la funcion autonetplan-necessary-integrity
autonetplan-necessary-integrity

# Si todos los ficheros necesarios para la instalacion estan "ok", preguntar si eliminar el repositorio

if [[ $autone == "ok" && $autoconf == "ok" && $autodirfilesearch == "ok" ]]; then
    # Los programas mas importantes se ha instalado correctamente
    echo -e "[\e[32m#\e[0m] Todos los ficheros mas importantes del programa se han instalado correctamente"
    # Llamar a la funcion purge-repo
    purge-repo
    # Programa instalado correctamente
    echo -e "[\e[32m#\e[0m] Programa instalado correctamente."
elif [[ $autone == "ok" ]]; then
    # Si este funciona al menos, enviar aviso de ok
    echo -e "[\e[32m#\e[0m] El fichero autonetplan se ha econtrado en la ruta correcta, puede ser llamado mediante 'autoentplan <parametros>'."
else
    # Ha ocurrido un error
    echo -e "[\e[31m#\e[0m] Ha ocurrido un error, puede que alguno de los ficheros no se encuentre en el sistema, revisar la integridad del programa."
fi

echo "[#] Las rutas del programa son: '$INSTALL_DIR/autonetplan' y '/etc/autonetplan'"
echo "[#] Mostrar la lista de ayuda del programa autonetplan, ejecute el comando: 'autonetplan -h'"