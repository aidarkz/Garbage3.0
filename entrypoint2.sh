#!/bin/sh

echo "[ENTRYPOINT] Starting selfping..."
/opt/selfping.sh &

echo "[ENTRYPOINT] Starting HLS Proxy..."
exec /opt/hlsp/hls-proxy -config-path /opt/hlsp/config -address 0.0.0.0 -port 8080
