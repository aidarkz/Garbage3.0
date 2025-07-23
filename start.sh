#!/bin/bash
set -e

# Запуск HLS-прокси (в фоне)
HLS-Proxy &

# Пинг keep-alive каждые 60 секунд
(
  while true; do
    curl -s -o /dev/null -w "[keep-alive] %{http_code} at %{time_total}s\n" http://127.0.0.1:8080/
    sleep 60
  done
) &

# Ждём завершения основного процесса (HLS-Proxy)
wait %1
