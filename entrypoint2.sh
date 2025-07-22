#!/bin/sh

echo "[ENTRYPOINT] Starting HLS Proxy..."

# запускаем selfping в фоне
/opt/selfping.sh &

# запускаем hls-proxy как основной процесс (НЕ в фоне)
exec /opt/hlsp/hls-proxy -config-path /opt/hlsp/config -address 0.0.0.0 -port 8080
