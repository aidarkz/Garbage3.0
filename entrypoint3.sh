#!/bin/bash

echo "[ENTRYPOINT] Starting IPTV proxy with watchdog..."

# Запускаем start.sh в фоне
./start.sh &
START_PID=$!
echo "[ENTRYPOINT] start.sh запущен с PID $START_PID"

# Вечный цикл проверки /status
while true; do
    sleep 15
    if ! curl -s --max-time 5 http://127.0.0.1:8080/status > /dev/null; then
        echo "[WATCHDOG] ❌ /status недоступен, перезапуск start.sh..."
        kill $START_PID 2>/dev/null
        sleep 1
        ./start.sh &
        START_PID=$!
        echo "[WATCHDOG] 🔁 start.sh перезапущен с PID $START_PID"
    fi
done
