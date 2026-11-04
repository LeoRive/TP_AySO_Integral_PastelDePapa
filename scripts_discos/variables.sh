
#!/bin/bash

#!!!!DEBES CAMBIAR EL NOMBRE DEL DISCO AL QUE A VOS TE APAREZCA SEGUN SU TAMANIO!!!!
DISCO_5G="/dev/sdc"
DISCO_3G="/dev/sdd"
DISCO_2G="/dev/sde"

# Particiones
PV_5G="${DISCO_5G}1"
PV_3G="${DISCO_3G}1"
PV_2G="${DISCO_2G}1"

SWAP_TRADICIONAL="${DISCO_2G}2"

# Grupos de volumenes
VG_DATOS="vg_datos"
VG_TEMP="vg_temp"

# Volumenes logicos
LV_DOCKER="/dev/${VG_DATOS}/lv_docker"
LV_WORK="/dev/${VG_DATOS}/lv_workareas"
LV_SWAP="/dev/${VG_TEMP}/lv_swap"

# Puntos de montaje
MONTAJE_DOCKER="/var/lib/docker"
MONTAJE_WORK="/work"

