#!/bin/bash

echo "[ENTRYPOINT] Starting IPTV proxy with watchdog..."

# Запускаем основной процесс в фоне
/start.sh &
MAIN_PID=$!
echo "[ENTRYPOINT] start.sh запущен с PID $MAIN_PID"

# watchdog loop
while true; do
    sleep 10

    # Пингуем статус
    if ! curl -s --max-time 5 http://127.0.0.1:8080/status > /dev/null; then
        echo "[WATCHDOG] ❌ /status недоступен, перезапуск start.sh..."

        # Убиваем процесс
        kill -9 $MAIN_PID 2>/dev/null

        # Перезапуск
        /start.sh &
        MAIN_PID=$!
        echo "[WATCHDOG] 🔁 start.sh перезапущен с PID $MAIN_PID"
    else
        echo "[WATCHDOG] ✅ /status жив"
    fi
done
