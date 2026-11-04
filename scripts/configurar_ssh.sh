
#!/bin/bash

# Creo la carpeta para guardar las claves publicas
mkdir -p /vagrant/ssh-keys

# Creo la carpeta .ssh del usuario vagrant
mkdir -p /home/vagrant/.ssh

# Genero la clave SSH
ssh-keygen -t ed25519 -N '' -f /home/vagrant/.ssh/id_ed25519

# Copipe la clave publica a la carpeta compartida
cp /home/vagrant/.ssh/id_ed25519.pub /vagrant/ssh-keys/$(hostname).pub

# Crep el archivo de claves autorizadas
touch /home/vagrant/.ssh/authorized_keys

# Agrego las claves publicas de las maquinas
cat /vagrant/ssh-keys/*.pub >> /home/vagrant/.ssh/authorized_keys

# Elimino las que estan repetidas
sort -u /home/vagrant/.ssh/authorized_keys -o /home/vagrant/.ssh/authorized_keys

# Configuro los permisos
chown -R vagrant:vagrant /home/vagrant/.ssh
chmod 700 /home/vagrant/.ssh
chmod 600 /home/vagrant/.ssh/authorized_keys
chmod 600 /home/vagrant/.ssh/id_ed25519
chmod 644 /home/vagrant/.ssh/id_ed25519.pub

