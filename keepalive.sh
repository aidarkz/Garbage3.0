#!/bin/bash

LOG=/app/keepalive.log

while true; do
    {
        echo "[$(date)] keepalive"
        echo "----- ps aux (top 10) -----"
        ps aux | head -n 10
        echo "----- memory (top 10 lines) -----"
        head -n 10 /proc/meminfo

        echo "----- process status -----"
        HLS=$(pgrep -f hls-proxy >/dev/null && echo "✅" || echo "❌")
        API=$(pgrep -f uvicorn    >/dev/null && echo "✅" || echo "❌")
        echo "[KEEPALIVE] HLS-PROXY: $HLS | API: $API | ts=$(date +%s)"
        echo "--------------------------"
        echo
    } >> "$LOG"

    # Также продублируем в stdout для логов Docker
    echo "[KEEPALIVE] HLS-PROXY: $HLS | API: $API | ts=$(date +%s)"

    sleep 20
done
