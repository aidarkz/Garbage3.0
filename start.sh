#!/bin/bash
set -e

# Запуск hls-proxy в фоне
/opt/hlsp/hls-proxy -address 0.0.0.0 -port 8080 &

HLS_PID=$!

# Keep-alive пинг каждые 60 секунд
(
  while kill -0 "$HLS_PID" 2>/dev/null; do
    CODE=$(curl -s -o /dev/null -w "%{http_code}" http://127.0.0.1:8080/)
    echo "[keep-alive] status: $CODE"
    sleep 60
  done
) &

# Ждём завершения основного процесса
wait "$HLS_PID"
