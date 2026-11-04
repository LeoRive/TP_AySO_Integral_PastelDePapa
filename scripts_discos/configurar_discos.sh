
#!/bin/bash
set -e
# Script principal de configuracion de discos
# Responsable: Arquitectura (R2)

echo "=========================================="
echo " INICIANDO CONFIGURACION DE DISCOS Y LVM"
echo "=========================================="

# 1. Particionamiento de discos
echo ""
echo "PASO 1: Particionamiento"
bash /vagrant/scripts_discos/particionamiento.sh

set -e

# 2. Creacion de PV, VG y LV
echo ""
echo "PASO 2: Configuracion de LVM"
bash /vagrant/scripts_discos/lvm.sh
set -e

# 3. Formateo de volumenes
echo ""
echo "PASO 3: Formateo"
bash /vagrant/scripts_discos/formateo.sh
set -e

# 4. Montaje y activacion de swap
echo ""
echo "PASO 4: Montaje y activacion de swap"
bash /vagrant/scripts_discos/montaje.sh
set -e

# 5. Configuracion de fstab
echo ""
echo "PASO 5: Configuracion de fstab"
bash /vagrant/scripts_discos/fstab.sh
set -e

echo ""
echo "=========================================="
echo " CONFIGURACION DE DISCOS FINALIZADA"
echo "=========================================="

