#!/bin/bash

echo "[SELF-PING] Starting loop..." >> /opt/selfping.log

while true; do
  date >> /opt/selfping.log
  curl -s http://127.0.0.1:8080/status >> /opt/selfping.log
  echo "" >> /opt/selfping.log
  sleep 20
done
