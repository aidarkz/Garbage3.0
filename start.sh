#!/bin/bash

echo "[INFO] Starting hls-proxy..."

# Запуск hls-proxy в фоне
/opt/hlsp/hls-proxy -address 0.0.0.0 -port 8080 &

HLS_PROXY_PID=$!

# Keep-alive цикл
echo "[INFO] hls-proxy запущен с PID: $HLS_PROXY_PID"
while kill -0 "$HLS_PROXY_PID" 2>/dev/null; do
    curl -s http://127.0.0.1:8080/health > /dev/null
    sleep 30
done

echo "[ERROR] hls-proxy завершился"
exit 1
