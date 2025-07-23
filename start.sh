#!/bin/bash

echo "[INFO] Starting hls-proxy..."

# Запуск прокси в фоне
/opt/hlsp/hls-proxy -address 0.0.0.0 -port 8080 &
HLS_PROXY_PID=$!

# Фоновый keep-alive curl пинг
(
  while true; do
    curl -s http://127.0.0.1:8080/ > /dev/null
    sleep 20
  done
) &

# Основной цикл: следим за процессом
while kill -0 "$HLS_PROXY_PID" 2>/dev/null; do
    sleep 5
done

echo "[ERROR] hls-proxy завершился"
exit 1
