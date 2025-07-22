#!/bin/sh

echo "[ENTRYPOINT] Starting HLS Proxy..."
/opt/hlsp/hls-proxy -config-path /opt/hlsp/config -address 0.0.0.0 -port 8080 &

sleep 2
echo "[ENTRYPOINT] Starting selfping..."
/opt/selfping.sh
