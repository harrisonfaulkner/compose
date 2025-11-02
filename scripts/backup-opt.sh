#!/bin/bash

SOURCE="/opt/"
BACKUP_ROOT="/mnt/backup"
DATE=$(date +%Y-%m-%d_%H-%M-%S)
DEST="$BACKUP_ROOT/$DATE"
LATEST="$BACKUP_ROOT/latest"
LOGFILE="/var/log/opt-backup.log"

echo "=== Backup started at $(date) ===" >> "$LOGFILE"

mkdir -p "$DEST"

# Use rclone with multi-threading
rclone sync "$SOURCE" "$DEST" \
  --transfers 8 \
  --checkers 16 \
  --exclude '*.tmp' \
  --exclude '*.log' \
  --exclude 'cache/**' \
  --log-level INFO \
  --log-file="$LOGFILE" \
  --stats 30s

if [ $? -eq 0 ]; then
    rm -f "$LATEST"
    ln -s "$DEST" "$LATEST"
    echo "=== Backup completed successfully at $(date) ===" >> "$LOGFILE"
else
    echo "=== Backup failed at $(date) ===" >> "$LOGFILE"
    exit 1
fi
