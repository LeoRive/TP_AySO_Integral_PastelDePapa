
#!/bin/bash
set -e

echo "Instalo herramientas de administración"
dnf install -y \
    openssh-server \
    openssh-clients \
    lvm2 \
    parted \
    util-linux \
    curl \
    git \
    vim \
    tree \
    ca-certificates \
    python3 \
    htop \
    tmux

echo "Configuro el repositorio oficial de Docker"
dnf config-manager addrepo \
    --from-repofile=https://download.docker.com/linux/fedora/docker-ce.repo

echo "Instalo Docker y Docker Compose"
dnf install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-buildx-plugin \
    docker-compose-plugin

echo "Agrego vagrant al grupo docker"
usermod -aG docker vagrant

echo "Habilito e inicio Docker"
systemctl enable --now docker

echo "Habilito el servicio SSH"
systemctl enable --now sshd

echo "Instalación de Fedora finalizada"

