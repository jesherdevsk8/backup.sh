#!/usr/bin/env bash
# ---------------------- [ Script backup ] -----------------------+
#        Script   : backup.sh                                     |
#        Author   : Jesher Minelli <jesherdevsk8@gmail.com>       |
#        Date     : ter 21 jun 2022                               |  
#        Use      : ln -s $PWD/backup.sh /usr/local/bin/bkp       |
# ----------------------------------------------------------------+

backup_path="$HOME/Documentos/"
external_storage="/media/jesher/Ventoy"
destination="/media/jesher/Ventoy/backups"
date_log=$(date "+%a %d %b %Y %H:%M:%S")
date_format=$(date "+%A %d-%m-%Y")
final_archive="backup-$date_format.tar.gz"
log_file="$PWD/backup.log"

[[ $UID -eq 0 ]] && echo "Do not need super user...." && exit 1

monit_backup(){
  if [ -f "$PWD/monit.sh" ]; then
    . "$PWD/monit.sh" &
    monit_pid=$!
  fi
}

backup(){
  monit_backup
  if tar -cpSzf "$destination/$final_archive" "$backup_path" &>/dev/null; then
    printf "[ $date_log ] BACKUP SUCCESSFULLY COMPLETED.\n" >> "$log_file"
    find "${destination}/" -name '*.gz' -mtime +1 -delete # Deleting files greater than two days
    kill $monit_pid
  else
    printf "[ $date_log ] THERE WAS AN ERROR BACKING UP...!!\n" >> "$log_file"
    kill $monit_pid
  fi
}

if ! mountpoint -q -- "$external_storage"; then # Device mounted ?
  printf "[ $date_log ] No such file or directory in "$destination"\n" >> "$log_file"
  exit 1
else
  mkdir -p "$destination"
	backup
fi
