
#!/bin/bash
set -e

# Crear y aprovisionar las dos máquinas
vagrant up

# Volver a configurar SSH cuando ambas hayan publicado sus claves
vagrant provision --provision-with configurar_ssh

# Ejecutar Ansible, ya con el ssh cruzado
vagrant provision VM2-Grupo-Ppapa --provision-with correr_ansible

echo "Máquinas levantadas y configuración SSH ejecutada."

