# Ansible - playbook - Grupo PastelDePapa

Responsable: R4 - Franco Perrotta

## Informacion:
- Playbook de Ansible que llama a los cuatro roles pedidos:
    - TP_INI
    - Alta_Usuarios_PastelDePapa
    - Sudoers_PastelDePapa
    - Instala-tools_PastelDePapa
- Ansible corre desde la VM2 (Fedora) y se conecta por ssh-key, sin contraseña,
  a las dos VM (192.168.56.10 Ubuntu/Testing y 192.168.56.11 Fedora/Produccion).
- Requiere ansible-core 2.20 o mas nuevo: Fedora 44 trae Python 3.14, que las
  versiones viejas de Ansible no soportan.

## Ejecucion:
Desde la carpeta del repo, en Windows:
```sh
bash levantar.sh
```
Levanta las VM, cruza las claves ssh y ejecuta el playbook.

Para ejecutar solo el playbook, con las VM ya levantadas:
```sh
vagrant provision VM2-Grupo-Ppapa --provision-with correr_ansible
```

A mano, dentro de la VM2 (parado en "ansible/"):
```sh
export ANSIBLE_CONFIG=/vagrant/ansible/ansible.cfg
ansible-playbook -i inventory/hosts playbook.yml
```

### Contenido:
- playbook.yml -> receta
- ansible.cfg -> configuracion local de ansible
- vars/main.yml -> variables globales: nombre del grupo, division,
  lista de integrantes y lista de programas a instalar
- inventory
    - hosts -> grupos testing (Ubuntu) y produccion (Fedora)
    - group_vars / host_vars -> variables por grupo o por host
- roles

| Nombre del rol | Función |
|---|---|
| TP_INI | Genera /tmp/Grupo/datos.txt (dueño vagrant) con el modulo template |
| Alta_Usuarios_PastelDePapa | Crea los grupos G_R1..G_R6 y el grupo del equipo, y un usuario por integrante con la clave de vagrant |
| Sudoers_PastelDePapa | Da sudo sin contraseña al grupo del equipo |
| Instala-tools_PastelDePapa | Instala htop, tmux y speedtest-cli |

### Comportamiento deseado:
- Se ejecuta contra los dos grupos del inventario, sin pedir clave de ssh ni de sudo.
- Es idempotente: una segunda ejecucion da changed=0.

## Como verificar:
- Al final del playbook: failed=0 en las dos IP.
- Dentro de una VM: `cat /tmp/Grupo/datos.txt` e `id R4_Franco`.

## Notas:
- La box fedora/44 no esta en el catalogo de Vagrant: hay que bajar el archivo
  .box y registrarlo a mano (`vagrant box add`) antes del primer `vagrant up`.