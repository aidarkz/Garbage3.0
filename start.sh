#!/bin/bash
set -e

# Запуск HLS-прокси (в фоне)
echo "[INFO] starting HLS-Proxy"
/opt/hlsp/HLS-Proxy &

# Keep-alive запрос каждые 60 сек
(
  while true; do
    curl -s -o /dev/null -w "[keep-alive] %{http_code} at %{time_total}s\n" http://127.0.0.1:8080/
    sleep 60
  done
) &

# Ждём завершения основного процесса
wait %1
