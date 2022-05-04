#!/usr/bin/env bash
#
# backup.sh - Faz backup completo para um dispositivo móvel
# Autor: Jesher Minelli Alves <jesherdevsk8@gmail.com>
# licença: GNU GPLv2
# Histórico: 
# 	   Versão inicial v1.0 01/03/2022 [ Jesher ]
#      Próxima feature [ Torne-o em um backup incremental ]
#	   Pŕoxima feature [ Fazer uma barra de progresso ]
#
# Testado: bash versão 5.0.17
#
# Torne o script executável em qualquer lugar
# Ex: sudo ln -s $HOME/github/Backup/backup.sh /usr/local/bin/backup
# ADICIONE AO CRON CASO PREFIRA
# execute como root - $ crontab -e
# 0 9 * * * /usr/local/sbin/backup.sh  <- Todo dia as 09:00 horas
# Visite o site: https://crontab.guru/
#
#
# -------------- VARIÁVEIS

backup_path="/home/jesher/Documentos" # Diretório para backup
external_storage="/media/jesher/kingston" # Dispositivo externo de destino
destination="/media/jesher/kingston/backups" # Diretório para ser criado dentro do dispositivo externo
date_log="$(date)" # Data erro log
date_format=$(date "+%A %d-%m-%Y") # Data do backup
final_archive="backup-$date_format.tar.gz" # Formato do arquivo
log_file="/var/log/daily-backup.log" # Arquivo de log
# Monitorar o arquvo de log
# tail -f /var/log/daily-backup.log ou less +F /var/log/daily-backup.log

# -------------- TESTES

[[ "$UID" -ne "0" ]] && { echo "Precisa de Root!!!"; exit 1 ;}

if ! mountpoint -q -- $external_storage; then # Pendrive plugado na máquina?
	printf "[$date_log] DEVICE NOT MOUNTED in: $external_storage CHECK IT.\n" >> $log_file
	exit 1
else 
	[[ ! -d "$destination" ]] && mkdir -p "$destination"
fi

# --------------- EXECUÇÃO

if tar -cpSzf "${external_storage}/${final_archive}" "$backup_path" &>/dev/null; then
	printf "[$date_log] BACKUP SUCCESS.\n" >> $log_file
else
	printf "[$date_log] BACKUP ERROR...!!\n" >> $log_file
fi

find ${destination}/*.gz -mtime +5 -delete # Excluir arquivos com mais de cinco dias
