#!/bin/sh

while true; do
  echo "[SELF-PING] Pinging localhost:8080"
  curl -s http://127.0.0.1:8080/health >/dev/null || echo "[SELF-PING] Failed"
  sleep 60
done
