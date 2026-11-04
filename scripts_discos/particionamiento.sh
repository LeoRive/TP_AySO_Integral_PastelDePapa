
#!/bin/bash

# Cargamos las variables
source /vagrant/scripts_discos/variables.sh

echo "Iniciando particionamiento de discos..."

# Disco de 5GB
if [ -b "$PV_5G" ]; then
    echo "La particion del disco de 5GB ya existe."
else
    sudo fdisk "$DISCO_5G" << EOF
n
p
1


t
8e
p
w
EOF
fi

# Disco de 3GB
if [ -b "$PV_3G" ]; then
    echo "La particion del disco de 3GB ya existe."
else
    sudo fdisk "$DISCO_3G" << EOF
n
p
1


t
8e
p
w
EOF
fi

# Disco de 2GB
if [ -b "$PV_2G" ] && [ -b "$SWAP_TRADICIONAL" ]; then
    echo "Las particiones del disco de 2GB ya existen."

elif [ ! -b "$PV_2G" ] && [ ! -b "$SWAP_TRADICIONAL" ]; then
    sudo fdisk "$DISCO_2G" << EOF
n
p
1

+1G
t
1
8e
n
p
2


t
2
82
p
w
EOF

else
    echo "ERROR: El disco de 2GB tiene una particion creada y otra no. Revisar manualmente."
    exit 1
fi

# Actualizamos la informacion de las particiones
sudo partprobe "$DISCO_5G"
sudo partprobe "$DISCO_3G"
sudo partprobe "$DISCO_2G"

echo "Particionamiento finalizado."

