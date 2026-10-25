
#!/bin/bash
#identificar cada VM por nombre -> ambas máquinas necesitan conocer las IP de la otra
set -e

# Eliminar entradas anteriores de estas VM
sed -i '/VM1-Grupo-Ppapa/d' /etc/hosts #Busca en /etc/hosts todas las líneas que contengan VM1-Grupo-Ppapa y las elimina
sed -i '/VM2-Grupo-Ppapa/d' /etc/hosts

# Agregar las direcciones de ambas VM
echo '192.168.56.10 VM1-Grupo-Ppapa' >> /etc/hosts #agrega al archivo /etc/hosts la IP
echo '192.168.56.11 VM2-Grupo-Ppapa' >> /etc/hosts

