#!/bin/bash

# Лог-файлы
LOG_DIR="/opt/hlsp/logs"
LOG_FILE="$LOG_DIR/proxy.log"

mkdir -p "$LOG_DIR"

echo "[start.sh] Starting HLS-Proxy at $(date)" >> "$LOG_FILE"

# Функция запуска
start_proxy() {
    echo "[start.sh] Launching HLS-Proxy..." >> "$LOG_FILE"
    /opt/hlsp/hls-proxy -address 0.0.0.0 -port 8080 >> "$LOG_FILE" 2>&1 &
    PROXY_PID=$!
    echo "[start.sh] Proxy PID: $PROXY_PID" >> "$LOG_FILE"
}

# Первый запуск
start_proxy

# Keep-alive цикл
while true; do
    if ! kill -0 $PROXY_PID 2>/dev/null; then
        echo "[start.sh] HLS-Proxy crashed at $(date), restarting..." >> "$LOG_FILE"
        start_proxy
    fi
    sleep 5
done
