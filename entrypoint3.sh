#!/bin/bash
echo "[ENTRYPOINT] Starting IPTV proxy with watchdog..."

# Запускаем основной процесс
/app/start.sh &
pid=$!
echo "[ENTRYPOINT] start.sh запущен с PID $pid"

while true; do
    sleep 30
    if curl -s http://127.0.0.1:8080/status | grep -q "OK"; then
        echo "[WATCHDOG] ✅ /status доступен"
    else
        echo "[WATCHDOG] ❌ /status недоступен, перезапуск start.sh..."
        kill $pid 2>/dev/null
        sleep 1
        /app/start.sh &
        pid=$!
        echo "[WATCHDOG] 🔁 start.sh перезапущен с PID $pid"
    fi
done
