#!/bin/sh

URL="http://127.0.0.1:8080/health"
INTERVAL=60

while true; do
  echo "[SELFPING] $(date) ping $URL"
  curl -s --max-time 5 "$URL" > /dev/null || echo "[SELFPING] FAIL"
  sleep "$INTERVAL"
done
