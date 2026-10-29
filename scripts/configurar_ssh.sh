
#!/bin/bash
set -e

# Crear una carpeta compartida para las claves publicas
mkdir -p /vagrant/ssh-keys

# Obtener el nombre de esta VM
HOSTNAME_VM=$(hostname)

# Crear una clave SSH si todavía no existe
if [ ! -f /home/vagrant/.ssh/id_ed25519 ]; then # Si no existe el archivo de clave privada, entonces ejecutá las instrucciones que siguen
  sudo -u vagrant mkdir -p /home/vagrant/.ssh #el comando debe ejecutarse como el usuario vagrant
#ssh-keygen : Es el programa que genera claves SSH
  sudo -u vagrant ssh-keygen -q -t ed25519 -N '' -f /home/vagrant/.ssh/id_ed25519
fi

#id_ed25519: clave privada. No se comparte ni se sube al repositorio.
#id_ed25519.pub: clave pública

# Publicar solamente la clave publica
cp /home/vagrant/.ssh/id_ed25519.pub \
  "/vagrant/ssh-keys/${HOSTNAME_VM}.pub" #la clave pública queda disponible para que la otra máquina pueda leerla

# Preparar authorized_keys
mkdir -p /home/vagrant/.ssh
touch /home/vagrant/.ssh/authorized_keys

# Autorizar la clave publica de la otra VM, si ya existe
for CLAVE in /vagrant/ssh-keys/*.pub; do 
  [ -f "$CLAVE" ] || continue #Si el archivo no existe, no intentes utilizarlo y pasá al siguiente

  cat "$CLAVE" >> /home/vagrant/.ssh/authorized_keys #agregar al final de un archivo sin borrar lo que ya contiene
done

# Eliminar duplicados y fijar permisos
sort -u /home/vagrant/.ssh/authorized_keys \
  -o /home/vagrant/.ssh/authorized_keys #por si se agrega varias veces la misma

chown -R vagrant:vagrant /home/vagrant/.ssh 
chmod 700 /home/vagrant/.ssh #Solo el propietario puede acceder al directorio
chmod 600 /home/vagrant/.ssh/authorized_keys #Solo el propietario puede leer y escribir el archivo
chmod 600 /home/vagrant/.ssh/id_ed25519 # (clave privada)NO DEBE SER ACCESIBLE PARA OTROS USUARIOS
chmod 644 /home/vagrant/.ssh/id_ed25519.pub #El propietario puede leer y escribir; los demás pueden leer

