
#!/bin/bash

# Configuracion de montaje automatico en fstab
# Responsable: Arquitectura (R2)

# Cargamos las variables
source /vagrant/scripts_discos/variables.sh

echo "Iniciando configuracion de fstab..."

# Realizamos una copia de seguridad solamente si no existe
if [ ! -f /etc/fstab.bak ]; then
    sudo cp /etc/fstab /etc/fstab.bak
fi

########################################################
# OBTENCION DE UUID
########################################################

UUID_LV_DOCKER=$(sudo blkid -s UUID -o value "$LV_DOCKER")
UUID_LV_WORK=$(sudo blkid -s UUID -o value "$LV_WORK")
UUID_LV_SWAP=$(sudo blkid -s UUID -o value "$LV_SWAP")
UUID_SWAP_TRAD=$(sudo blkid -s UUID -o value "$SWAP_TRADICIONAL")

########################################################
# LV_DOCKER
########################################################

if [ "$UUID_LV_DOCKER" == "" ]; then
    echo "ERROR: No se pudo obtener el UUID de lv_docker."

elif sudo grep -q "$UUID_LV_DOCKER" /etc/fstab; then
    echo "lv_docker ya esta configurado en fstab."

else
    echo "Agregando lv_docker a fstab..."
    echo "UUID=$UUID_LV_DOCKER $MONTAJE_DOCKER ext4 defaults 0 2" | sudo tee -a /etc/fstab
fi

########################################################
# LV_WORK
########################################################

if [ "$UUID_LV_WORK" == "" ]; then
    echo "ERROR: No se pudo obtener el UUID de lv_workareas."

elif sudo grep -q "$UUID_LV_WORK" /etc/fstab; then
    echo "lv_workareas ya esta configurado en fstab."

else
    echo "Agregando lv_workareas a fstab..."
    echo "UUID=$UUID_LV_WORK $MONTAJE_WORK ext4 defaults 0 2" | sudo tee -a /etc/fstab
fi

########################################################
# LV_SWAP
########################################################

if [ "$UUID_LV_SWAP" == "" ]; then
    echo "ERROR: No se pudo obtener el UUID de lv_swap."

elif sudo grep -q "$UUID_LV_SWAP" /etc/fstab; then
    echo "lv_swap ya esta configurado en fstab."

else
    echo "Agregando lv_swap a fstab..."
    echo "UUID=$UUID_LV_SWAP none swap defaults 0 0" | sudo tee -a /etc/fstab
fi

########################################################
# SWAP TRADICIONAL
########################################################

if [ "$UUID_SWAP_TRAD" == "" ]; then
    echo "ERROR: No se pudo obtener el UUID del swap tradicional."

elif sudo grep -q "$UUID_SWAP_TRAD" /etc/fstab; then
    echo "El swap tradicional ya esta configurado en fstab."

else
    echo "Agregando swap tradicional a fstab..."
    echo "UUID=$UUID_SWAP_TRAD none swap defaults 0 0" | sudo tee -a /etc/fstab
fi

# Actualizamos la configuracion de systemd
sudo systemctl daemon-reload

echo "Configuracion de fstab finalizada."

