#!/bin/sh
echo "[ENTRYPOINT] Starting HLS-Proxy..."
/opt/hlsp/hls-proxy -address 0.0.0.0:8080 &

echo "[ENTRYPOINT] Entrypoint finished, keeping container alive"
# После выходя из entrypoint, tail будет держать контейнер в режиме работы
