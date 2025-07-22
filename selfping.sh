#!/bin/sh

# Ждём запуска hls-proxy
until curl -s --max-time 3 http://127.0.0.1:8080/health >/dev/null; do
  echo "[SELF-PING] Waiting for hls-proxy..."
  sleep 2
done

while true; do
  echo "[SELF-PING] Pinging localhost:8080"
  curl --max-time 5 --connect-timeout 2 -s http://127.0.0.1:8080/health >/dev/null || echo "[SELF-PING] Failed"
  sleep 60
done
