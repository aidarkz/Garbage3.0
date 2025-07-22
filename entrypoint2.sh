#!/bin/sh
set -e

echo "[ENTRYPOINT] Запуск hls-proxy..."
/opt/hlsp/hls-proxy -config-path /opt/hlsp/config -address 0.0.0.0 -port 8080 &
PID_PROXY=$!

echo "[ENTRYPOINT] Запуск selfping..."
/selfping.sh &
PID_PING=$!

# Ловим завершение
wait $PID_PROXY
