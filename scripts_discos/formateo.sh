
#!/bin/bash

# Formateo de particiones y volumenes logicos
# Responsable: Arquitectura (R2)

# Cargamos las variables
source /vagrant/scripts_discos/variables.sh

#para tebnenr en cuenta: sudo blkid -s TYPE -o value /dev/sda1 (Para obtener solo el tipo de sistema de archivos (TYPE)

echo "Iniciando formateo de dispositivos..."

########################################################
# FORMATEO DE LV_DOCKER
########################################################

FORMATO_LV_DOCKER=$(sudo blkid -s TYPE -o value "$LV_DOCKER")

if [ "$FORMATO_LV_DOCKER" == "ext4" ]; then
    echo "lv_docker ya esta formateado en ext4."
else
    if [ "$FORMATO_LV_DOCKER" == "" ]; then
        echo "Formateando lv_docker en ext4..."
        sudo mkfs.ext4 "$LV_DOCKER"
    else
        echo "ERROR: lv_docker tiene otro formato: $FORMATO_LV_DOCKER"
    fi
fi

########################################################
# FORMATEO DE LV_WORK
########################################################

FORMATO_LV_WORK=$(sudo blkid -s TYPE -o value "$LV_WORK")

if [ "$FORMATO_LV_WORK" == "ext4" ]; then
    echo "lv_workareas ya esta formateado en ext4."
else
    if [ "$FORMATO_LV_WORK" == "" ]; then
        echo "Formateando lv_workareas en ext4..."
        sudo mkfs.ext4 "$LV_WORK"
    else
        echo "ERROR: lv_workareas tiene otro formato: $FORMATO_LV_WORK"
    fi
fi

########################################################
# FORMATEO DE LV_SWAP
########################################################

FORMATO_LV_SWAP=$(sudo blkid -s TYPE -o value "$LV_SWAP")

if [ "$FORMATO_LV_SWAP" == "swap" ]; then
    echo "lv_swap ya esta preparado como swap."
else
    if [ "$FORMATO_LV_SWAP" == "" ]; then
        echo "Preparando lv_swap como swap..."
        sudo mkswap "$LV_SWAP"
    else
        echo "ERROR: lv_swap tiene otro formato: $FORMATO_LV_SWAP"
    fi
fi

########################################################
# FORMATEO DE SWAP TRADICIONAL
########################################################

FORMATO_SWAP_TRAD=$(sudo blkid -s TYPE -o value "$SWAP_TRADICIONAL")

if [ "$FORMATO_SWAP_TRAD" == "swap" ]; then
    echo "El swap tradicional ya esta preparado."
else
    if [ "$FORMATO_SWAP_TRAD" == "" ]; then
        echo "Preparando swap tradicional..."
        sudo mkswap "$SWAP_TRADICIONAL"
    else
        echo "ERROR: el swap tradicional tiene otro formato: $FORMATO_SWAP_TRAD"
    fi
fi

echo "Formateo finalizado."

