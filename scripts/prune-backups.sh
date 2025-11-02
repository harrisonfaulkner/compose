#!/bin/bash

BACKUP_ROOT="/mnt/backup"
KEEP_DAYS=30  # Keep backups from last 30 days
LOGFILE="/var/log/opt-backup.log"

echo "=== Pruning old backups at $(date) ===" >> "$LOGFILE"

# Find and delete backups older than KEEP_DAYS
find "$BACKUP_ROOT" -maxdepth 1 -type d -name "20*" -mtime +$KEEP_DAYS | while read backup; do
    echo "Deleting old backup: $backup" >> "$LOGFILE"
    rm -rf "$backup"
done

echo "=== Pruning completed at $(date) ===" >> "$LOGFILE"
