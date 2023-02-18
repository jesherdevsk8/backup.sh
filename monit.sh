#!/usr/bin/env bash
# --------------------- [ Monitoring backup ] ------------------------+
#        Script      : monit.sh                                       |
#		     Description : monitoring backup                              | 
#        Author      : Jesher Minelli <jesherdevsk8@gmail.com>        |
#        Date        : ter 21 jun 2022                                |  
#        Use         : ./monit.sh                                     |
# --------------------------------------------------------------------+
external_storage="/media/jesher/Ventoy"
backup_dir="${external_storage}/backups"

if mountpoint -q -- "$external_storage"; then # Device mounted ?
  if [[ -d "${backup_dir}" ]]; then
    while true; do
        sleep 2; clear
        du -sh "${backup_dir}"/*.tar.gz
    done
  else
    echo "No such file or directory"; exit 1
  fi
fi
