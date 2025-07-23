#!/bin/bash

LOG_FILE="/opt/hlsp/logs/proxy.log"
echo "[INIT] Starting HLS proxy at $(date)" >> "$LOG_FILE"

# Убедимся, что лог-файл существует
mkdir -p /opt/hlsp/logs
touch "$LOG_FILE"

# Запуск hls_proxy в foreground и логирование
exec /opt/hlsp/hls-proxy >> "$LOG_FILE" 2>&1
