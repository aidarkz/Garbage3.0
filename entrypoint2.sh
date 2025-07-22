#!/bin/sh

echo "[entrypoint] Container started at $(date)"

run_proxy() {
    echo "[entrypoint] Starting hls-proxy at $(date)"
    /opt/hlsp/hls-proxy -config-path /opt/hlsp/config -address 0.0.0.0 -port 8080 &
    PROXY_PID=$!
}

restart_proxy() {
    echo "[entrypoint] Restarting hls-proxy due to healthcheck failure at $(date)"
    kill -9 "$PROXY_PID" 2>/dev/null
    wait "$PROXY_PID" 2>/dev/null
    run_proxy
}

# Запуск прокси первый раз
run_proxy

# Watchdog-процесс: мониторит /health
(
FAIL_COUNT=0
while true; do
    sleep 60

    if curl -s http://uhnauyno.deploy.cx/status > /dev/null; then
        echo "[watchdog] Healthcheck OK at $(date)"
        FAIL_COUNT=0
    else
        echo "[watchdog] Healthcheck FAILED at $(date)"
        FAIL_COUNT=$((FAIL_COUNT + 1))
    fi

    if [ "$FAIL_COUNT" -ge 3 ]; then
        restart_proxy
        FAIL_COUNT=0
    fi
done
) &

# Ждем завершения основного процесса (никогда не завершится в норме)
wait "$PROXY_PID"
