
#!/bin/bash
set -e

echo "Evito la interacción durante la instalación"
export DEBIAN_FRONTEND=noninteractive

echo "Actualizo la lista de paquetes"
apt-get update > /dev/null

echo "Instalo herramientas de administración"
apt-get install -y \
    openssh-server \
    openssh-client \
    lvm2 \
    parted \
    util-linux \
    curl \
    git \
    vim \
    tree \
    ca-certificates \
    gnupg \
    python3 \
    htop \
    tmux < /dev/null > /dev/null

echo "Preparo el repositorio oficial de Docker"
install -m 0755 -d /etc/apt/keyrings

curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
    -o /etc/apt/keyrings/docker.asc

chmod a+r /etc/apt/keyrings/docker.asc

. /etc/os-release

echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu ${UBUNTU_CODENAME:-$VERSION_CODENAME} stable" \
    > /etc/apt/sources.list.d/docker.list

echo "Actualizo la lista de paquetes con el repositorio de Docker"
apt-get update > /dev/null

echo "Instalo Docker y Docker Compose"
apt-get install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-buildx-plugin \
    docker-compose-plugin < /dev/null > /dev/null

echo "Agrego vagrant al grupo docker"
usermod -aG docker vagrant

echo "Habilito e inicio Docker"
systemctl enable --now docker

echo "Instalación de Ubuntu finalizada"

