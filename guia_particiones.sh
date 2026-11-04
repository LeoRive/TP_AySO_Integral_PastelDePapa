#!/bin/bash

"=========================================="
#Configuración manual de discos y LVM – R2
"========================================"

"PASO 1. IDENTIFICA LOS DISCOS"
#Identificar los discos de 5 GB, 3 GB y 2 GB
lsblk
sudo fdisk -l

"Paso 2. Particionar"
sudo fdisk /dev/sdc #asi se llama el disco que tengo yo de 5GB: /dev/sdc, cambialo por el tuyo de 5GB
#dentro de la interacion poner:
n: nueva partición.
p: primaria.
1: número de partición.
Enter: sector inicial predeterminado.
Enter: sector final predeterminado.
t: cambiar tipo.
8e: Linux LVM.
w: guardar.

#ahora con el de 3GB (repetir):
sudo fdisk /dev/sdd (repito, cambienlo al nombre de su disco de 3GB)
#dentro de la interacion poner:
n: nueva partición.
p: primaria.
1: número de partición.
Enter: sector inicial predeterminado.
Enter: sector final predeterminado.
t: cambiar tipo.
8e: Linux LVM.
w: guardar.

#ahora con el de 2GB- hay que particionarlo en 2 partes,uno de 1GB de tipo LVM y lo que queda de tipo swap tradicional
sudo fdisk /dev/sde
n
p
1
enter
+1G
t
1
8e
n
p
2
enter
enter
t
2
82
p
w

#Actualizamos la info:
sudo partprobe
lsblk

"Paso 3. Crear los PV" #con los nombres que aparecen en sus vm 
sudo pvcreate /dev/sdc1 #(1 particion del de 5GB)
sudo pvcreate /dev/sdd1 #(1 particion del de 3GB)
sudo pvcreate /dev/sde1 #(1 particion del de 2GB) la segunda es la de swap tradicional

"Paso 4. Crear los VG"
sudo vgcreate vg_datos /dev/sdc1
sudo vgcreate vg_temp /dev/sdd1 /dev/sde1

"Paso 5. Crear los LV"
sudo lvcreate -L 10M -n lv_docker vg_datos

sudo lvcreate -L 2.5G -n lv_workareas vg_datos

sudo lvcreate -L 2.5G -n lv_swap vg_temp


"Paso 6. Formatear"
sudo mkfs.ext4 /dev/vg_datos/lv_docker

sudo mkfs.ext4 /dev/vg_datos/lv_workareas

sudo mkswap /dev/vg_temp/lv_swap

sudo mkswap /dev/sde2


"Paso 7. Crear puntos de montaje"
sudo mkdir -p /var/lib/docker
sudo mkdir -p /work

"Paso 8. Montar"
sudo mount /dev/vg_datos/lv_docker /var/lib/docker

sudo mount /dev/vg_datos/lv_workareas /work


"Paso 9. Activar swap"
sudo swapon /dev/vg_temp/lv_swap
sudo swapon /dev/sde2

"Paso 10. Configurar fstab para que queden persistentes"

#1)Obtener los UUID de :
sudo blkid
   #podes conseguirlos directamente asi:
  	sudo blkid -s UUID -o value /dev/vg_datos/lv_docker
	sudo blkid -s UUID -o value /dev/vg_datos/lv_workareas
	sudo blkid -s UUID -o value /dev/vg_temp/lv_swap
	sudo blkid -s UUID -o value /dev/sde2 #(cambia el nombre de la particion al que tengas en tu vm)


#2)Abrir:
sudo nano /etc/fstab

#3)Agregar las cuatro entradas al final de /etc/fstab , reemplazando cada UUID por el correspondiente:
UUID=UUID_DOCKER /var/lib/docker ext4 defaults 0 2
UUID=UUID_WORK /work ext4 defaults 0 2
UUID=UUID_LV_SWAP none swap defaults 0 0
UUID=UUID_SWAP_TRAD none swap defaults 0 0


#4)Guardar y comprobar:
sudo systemctl daemon-reload
sudo mount -a
sudo swapon -a

"Paso 11. Verificar"
lsblk
#deberia aparecer algo asi entre lo que muestre:
"sdc                         8:32   0     5G  0 disk
└─sdc1                      8:33   0     5G  0 part
  ├─vg_datos-lv_docker    253:0    0    12M  0 lvm  /var/lib/docker
  └─vg_datos-lv_workareas 253:1    0   2.5G  0 lvm  /work
sdd                         8:48   0     3G  0 disk
└─sdd1                      8:49   0     3G  0 part
  └─vg_temp-lv_swap       253:2    0   2.5G  0 lvm  [SWAP]
sde                         8:64   0     2G  0 disk
├─sde1                      8:65   0     1G  0 part
└─sde2                      8:66   0  1023M  0 part [SWAP]"

sudo pvs
#dberia aparecer algo asi: 
"PV         VG       Fmt  Attr PSize    PFree
  /dev/sdc1  vg_datos lvm2 a--    <5.00g    2.48g
  /dev/sdd1  vg_temp  lvm2 a--    <3.00g  508.00m
  /dev/sde1  vg_temp  lvm2 a--  1020.00m 1020.00m
"

sudo vgs
"  VG       #PV #LV #SN Attr   VSize  VFree
  vg_datos   1   2   0 wz--n- <5.00g 2.48g
  vg_temp    2   1   0 wz--n-  3.99g 1.49g"

sudo lvs
"  LV           VG       Attr       LSize  Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
  lv_docker    vg_datos -wi-ao---- 12.00m
  lv_workareas vg_datos -wi-ao----  2.50g
  lv_swap      vg_temp  -wi-ao----  2.50g"

df -h #muestra los sistemas de archivos montados y espacio disponible
#en una parte tenes que ver que esten montados algo asi:
"/dev/mapper/vg_datos-lv_docker     7.3M  236K  6.2M   4% /var/lib/docker
/dev/mapper/vg_datos-lv_workareas  2.4G   24K  2.3G   1% /work
"
swapon --show #Muestra los dispositivos swap activos
#tenes que ver algo asi, dos swap activas:
"NAME      TYPE       SIZE USED PRIO
/dev/sde2 partition 1023M   0B   -2
/dev/dm-2 partition  2.5G   0B   -3
"







