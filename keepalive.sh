#!/bin/bash

LOG_FILE="/app/keepalive-cron.log"

while true; do
  TIMESTAMP=$(date +%s)
  HLS_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://127.0.0.1:8282/health)
  API_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://127.0.0.1/api/status)

  MEM=$(cat /sys/fs/cgroup/memory.current 2>/dev/null)
  CPU=$(cat /sys/fs/cgroup/cpu.stat 2>/dev/null | grep usage_usec | awk '{sum += $2} END {print sum}')

  echo "[KEEPALIVE] HLS-PROXY: $([[ $HLS_STATUS == 200 ]] && echo ✅ || echo ❌) | API: $([[ $API_STATUS == 200 ]] && echo ✅ || echo ❌) | ts=$TIMESTAMP | mem=${MEM:-?} | cpu=${CPU:-?}" >> "$LOG_FILE"

  # дополнительно «шевелим» систему:
  cat /proc/loadavg > /dev/null
  cat /proc/meminfo > /dev/null
  date > /dev/null
  sleep 20
done

