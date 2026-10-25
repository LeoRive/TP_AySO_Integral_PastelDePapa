#!/bin/bash
clear

###############################
#
# Parametros:
#  - Lista Dominios y URL
#
#  Tareas:
#  - Se debera generar la estructura de directorio pedida con 1 solo comando con las tecnicas enseñadas en clases
#  - Generar los archivos de logs requeridos.
#
###############################
LISTA=$1

<<<<<<< HEAD
LOG_FILE="/var/log/status_url.log"
=======
LOG_FILE="status_URL.log"


ANT_IFS=$IFS
IFS=$'\n'

#---- Dentro del bucle ----#
  # Obtener el código de estado HTTP
  STATUS_CODE=$(curl -L -o /dev/null -w '%{http_code}' -s "$URL")

  # Fecha y hora actual en formato yyyymmdd_hhmmss
  TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

if [[ "$STATUS_CODE" == "200" ]]; then
     CARPETA="ok"
elif [[ "$STATUS_CODE" -ge 400 && "$STATUS_CODE" -le 499 ]]; then
     CARPETA="Error/cliente"
elif [[ "$STATUS_CODE" -ge 500 && "$STATUS_CODE" -le 599 ]]; then
     CARPETA="Error/servidor"
else
     CARPETA="Error"
fi

mkdir -p "/tmp/head-check/$CARPETA"
echo "$TIMESTAMP - Code:$STATUS_CODE - URL:$URL" >> "/tmp/head-check/$CARPETA/$DOMINIO.log"

 # Registrar en el archivo /var/log/status_url.log
  echo "$TIMESTAMP - Code:$STATUS_CODE - URL:$URL" |sudo tee -a  "$LOG_FILE"




#-------------------------#

IFS=$ANT_IFS
