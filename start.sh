#!/bin/bash

echo "[INFO] Starting hls-proxy..."

# Запуск hls-proxy в фоне
/opt/hlsp/hls-proxy -address 0.0.0.0 -port 8080 &

# PID отслеживание
HLS_PROXY_PID=$!

# ТAIL-лог если stdout есть, либо просто keep-alive цикл
echo "[INFO] hls-proxy запущен с PID: $HLS_PROXY_PID"
while kill -0 "$HLS_PROXY_PID" 2>/dev/null; do
    sleep 5
done

echo "[ERROR] hls-proxy завершился"
exit 1
