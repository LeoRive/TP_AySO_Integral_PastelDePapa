# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  # VM 1: Ubuntu para Testing
  config.vm.define "VM1-Grupo-Ppapa" do |ubuntu| #le dice a vagrant que va a definir una VM

    ubuntu.vm.box = "ubuntu/jammy64" #imagen base de ubuntu/ box compatible para crear la VM
    ubuntu.vm.hostname = "VM1-Grupo-Ppapa" #nombre que Vagrant usa para identificarla en comandos como vagrant ssh

    ubuntu.vm.network "private_network", :name => '', ip: "192.168.56.10"

    # Los cuatro discos van SOLAMENTE en Ubuntu
    ubuntu.vm.disk :disk, size: "5GB", name: "disco_5G"
    ubuntu.vm.disk :disk, size: "3GB", name: "disco_3G"
    ubuntu.vm.disk :disk, size: "2GB", name: "disco_2G"
    ubuntu.vm.disk :disk, size: "1GB", name: "disco_reservado"

    ubuntu.vm.provider "virtualbox" do |vb|
      vb.name = "VM1-Grupo-Ppapa"
      vb.memory = 1536
      vb.cpus = 1
    end


    # Configuración inicial
    ubuntu.vm.provision "shell",
      path: "scripts/base.sh"

    #configura los nombres e IP
    ubuntu.vm.provision "shell",
      path: "scripts/configurar_hosts.sh"

    #instala herramientas basicas de ubuntu
    ubuntu.vm.provision "shell",
      path: "scripts/instalar_ubuntu.sh"

    # Configurar las claves SSH
    ubuntu.vm.provision "shell",
      name: "configurar_ssh",
      path: "scripts/configurar_ssh.sh"

  end
##############################################################
  # VM 2: Fedora para Producción
  config.vm.define "VM2-Grupo-Ppapa" do |fedora|

    fedora.vm.box = "fedora/44" #imagen base de Fedora/ box compatible para crear la VM
    fedora.vm.hostname = "VM2-Grupo-Ppapa" #nombre que Vagrant usa para identificarla en comandos como vagrant ssh

    fedora.vm.network "private_network", :name => '', ip: "192.168.56.11"

    # Fedora NO tiene los discos adicionales

    fedora.vm.provider "virtualbox" do |vb|
      vb.name = "VM2-Grupo-Ppapa"
      vb.memory = 1536
      vb.cpus = 1
    end

    fedora.vm.provision "shell",
      path: "scripts/base.sh"

    #configura los nombres e IP
    fedora.vm.provision "shell",
      path: "scripts/configurar_hosts.sh"

    #instala herramientas basicas de fedora
    fedora.vm.provision "shell",
      path: "scripts/instalar_fedora.sh"

# Configurar las claves SSH
    fedora.vm.provision "shell",
      name: "configurar_ssh",
      path: "scripts/configurar_ssh.sh"

  end

end

