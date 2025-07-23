#!/bin/bash

echo "[INFO] Starting HLS-Proxy 8.4.8"

while true; do
  /opt/hlsp/hls-proxy -address 0.0.0.0 -port 8080
  echo "[WARN] hls-proxy crashed or exited. Restarting in 3 seconds..."
  sleep 3
done
