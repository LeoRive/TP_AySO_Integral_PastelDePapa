#!/bin/bash
set -e #hace que el script se detenga si falla un comando

# Crear una regla para sudo sin contraseña
echo 'vagrant ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/vagrant # escribe la regla en /etc/sudoers.d/vagrant

# Proteger el archivo de permisos incorrectos
chmod 440 /etc/sudoers.d/vagrant

# Comprobar que la regla sea válida
visudo -cf /etc/sudoers.d/vagrant
