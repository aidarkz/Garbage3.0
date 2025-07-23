#!/bin/bash

LOG_FILE="/opt/hlsp/logs/proxy.log"
echo "[INIT] Starting HLS proxy at $(date)" >> "$LOG_FILE"

/opt/hlsp/hls_proxy >> "$LOG_FILE" 2>&1 &

# Keep-alive, чтобы контейнер не завершался
while true; do
    echo "[ALIVE] $(date)" >> "$LOG_FILE"
    sleep 60
done
