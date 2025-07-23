#!/bin/bash

# Запуск nginx, если нужен
service nginx start

# Запуск HLS-прокси в фоне
/opt/hlsp/hls-proxy -address 0.0.0.0:8080 &

# PID для отслеживания
PID=$!

# Цикл пинга к /health и перезапуска, если процесс упал
while true; do
    sleep 30

    # Проверяем жив ли процесс
    if ! kill -0 "$PID" 2>/dev/null; then
        echo "[ERROR] hls-proxy crashed, restarting..."
        /opt/hlsp/hls-proxy -address 0.0.0.0:8080 &
        PID=$!
        continue
    fi

    # Keep-alive пинг
    curl -s http://127.0.0.1:8080/health >/dev/null || echo "[WARN] /health unavailable"
done
