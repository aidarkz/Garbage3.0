#!/bin/bash

HLS_PROXY_BIN="/opt/hlsp/hls-proxy"
PORT=8080
CHECK_INTERVAL=10

start_proxy() {
    echo "[START] Запуск HLS-прокси..."
    $HLS_PROXY_BIN -address 0.0.0.0 -port $PORT &
    PROXY_PID=$!
}

check_status() {
    curl -s "http://127.0.0.1:$PORT/status" | grep -q "uptime"
}

# Бесконечный цикл слежения
while true; do
    start_proxy

    while kill -0 "$PROXY_PID" 2>/dev/null; do
        sleep $CHECK_INTERVAL
        if ! check_status; then
            echo "[WARN] /status недоступен. Перезапуск HLS-прокси..."
            kill -9 "$PROXY_PID"
            wait "$PROXY_PID" 2>/dev/null
            break
        fi
    done

    echo "[INFO] HLS-прокси завершился. Перезапуск через 5 секунд..."
    sleep 5
done
