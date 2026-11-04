
#!/bin/bash

# Montaje de volumenes logicos y activacion de swap
# Responsable: Arquitectura (R2)

# Cargamos las variables
source /vagrant/scripts_discos/variables.sh

echo "Iniciando montaje de dispositivos..."

########################################################
# CREACION DE CARPETAS
########################################################

sudo mkdir -p "$MONTAJE_DOCKER"
sudo mkdir -p "$MONTAJE_WORK"

########################################################
# MONTAJE DE LV_WORK
########################################################

MONTAJE_ACTUAL_WORK=$(df "$LV_WORK" | head -n 2 | tail -1 | awk '{print $6}')

if [ "$MONTAJE_ACTUAL_WORK" == "$MONTAJE_WORK" ]; then
    echo "lv_workareas ya esta montado en $MONTAJE_WORK."

elif [ "$MONTAJE_ACTUAL_WORK" == "" ]; then
    echo "Montando lv_workareas..."
    sudo mount "$LV_WORK" "$MONTAJE_WORK"

else
    echo "ERROR: lv_workareas esta montado en otra ubicacion: $MONTAJE_ACTUAL_WORK"
fi

########################################################
# MONTAJE DE LV_DOCKER
########################################################

MONTAJE_ACTUAL_DOCKER=$(df "$LV_DOCKER" | head -n 2 | tail -1 | awk '{print $6}')

if [ "$MONTAJE_ACTUAL_DOCKER" == "$MONTAJE_DOCKER" ]; then
    echo "lv_docker ya esta montado en $MONTAJE_DOCKER."

elif [ "$MONTAJE_ACTUAL_DOCKER" == "" ]; then
    echo "Montando lv_docker..."
    sudo mount "$LV_DOCKER" "$MONTAJE_DOCKER"

else
    echo "ERROR: lv_docker esta montado en otra ubicacion: $MONTAJE_ACTUAL_DOCKER"
fi

########################################################
# ACTIVACION DE LV_SWAP
########################################################

if sudo swapon --show | grep -q "$LV_SWAP"; then
    echo "lv_swap ya esta activo."

else
    echo "Activando lv_swap..."
    sudo swapon "$LV_SWAP"
fi

########################################################
# ACTIVACION DE SWAP TRADICIONAL
########################################################

if sudo swapon --show | grep -q "$SWAP_TRADICIONAL"; then
    echo "El swap tradicional ya esta activo."

else
    echo "Activando swap tradicional..."
    sudo swapon "$SWAP_TRADICIONAL"
fi

echo "Montaje y activacion de swap finalizados."

