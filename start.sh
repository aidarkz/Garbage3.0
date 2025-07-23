#!/bin/bash

echo "[start.sh] Запуск HLS Proxy..."
/opt/hlsp/hls-proxy -address 0.0.0.0 -port 8080

# Предотвращаем завершение контейнера
echo "[start.sh] Контейнер будет оставаться живым"
tail -f /dev/null
