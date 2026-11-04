
#!/bin/bash

# Particiones y LVM
# Responsable: Arquitectura (R2)

# Cargamos las variables
source /vagrant/scripts_discos/variables.sh

echo "Iniciando configuracion de LVM"

########################################################
# CREACION DE LOS PVs
########################################################

# PV de 5G
if sudo pvs "$PV_5G" ; then
    echo "El PV de 5G ya existe."
else
    echo "Creando PV de 5G..."
    sudo pvcreate "$PV_5G"
fi

# PV de 3G
if sudo pvs "$PV_3G" ; then
    echo "El PV de 3G ya existe."
else
    echo "Creando PV de 3G..."
    sudo pvcreate "$PV_3G"
fi

# PV de 2G
if sudo pvs "$PV_2G" ; then
    echo "El PV de 2G ya existe."
else
    echo "Creando PV de 2G..."
    sudo pvcreate "$PV_2G"
fi

########################################################
# CREACION DE LOS VGs
########################################################

# VG_DATOS
if sudo vgs "$VG_DATOS" ; then
    echo "El VG vg_datos ya existe."
else
    echo "Creando VG vg_datos..."
    sudo vgcreate "$VG_DATOS" "$PV_5G"
fi

# VG_TEMP
if sudo vgs "$VG_TEMP" ; then
    echo "El VG vg_temp ya existe."
else
    echo "Creando VG vg_temp..."
    sudo vgcreate "$VG_TEMP" "$PV_3G" "$PV_2G"
fi

########################################################
# CREACION DE LOS LVs
########################################################

# LV_DOCKER
if sudo lvs "$LV_DOCKER" ; then
    echo "El LV lv_docker ya existe."
else
    echo "Creando LV lv_docker..."
    sudo lvcreate -L 10M -n lv_docker "$VG_DATOS"
fi

# LV_WORK
if sudo lvs "$LV_WORK" ; then
    echo "El LV lv_workareas ya existe."
else
    echo "Creando LV lv_workareas..."
    sudo lvcreate -L 2.5G -n lv_workareas "$VG_DATOS"
fi

# LV_SWAP
if sudo lvs "$LV_SWAP" ; then
    echo "El LV lv_swap ya existe."
else
    echo "Creando LV lv_swap..."
    sudo lvcreate -L 2.5G -n lv_swap "$VG_TEMP"
fi

echo "Configuracion de LVM finalizada."

