#!/bin/bash

WATCHDOG_INTERVAL=60
WATCHDOG_TIMEOUT=5

start_proxy() {
    echo "[START] Запуск HLS-прокси..."
    nohup ./start.sh > proxy.log 2>&1 &
    echo $! > /tmp/proxy.pid
    echo "[WATCHDOG] 🔁 start.sh перезапущен с PID $!"
}

stop_proxy() {
    if [ -f /tmp/proxy.pid ]; then
        PID=$(cat /tmp/proxy.pid)
        if ps -p "$PID" > /dev/null; then
            echo "[WATCHDOG] 🛑 Остановка старого процесса PID $PID"
            kill "$PID"
            sleep 2
        fi
        rm -f /tmp/proxy.pid
    else
        echo "[WATCHDOG] ⚠️ Нет PID-файла, ищем вручную"
        PID=$(lsof -ti:8080)
        if [ -n "$PID" ]; then
            echo "[WATCHDOG] 🛑 Убиваем процесс на 8080: PID $PID"
            kill "$PID"
            sleep 2
        fi
    fi
}

watchdog_loop() {
    while true; do
        sleep "$WATCHDOG_INTERVAL"

        echo "[WATCHDOG] 🔎 Проверка доступности /status"
        if ! curl -s --max-time "$WATCHDOG_TIMEOUT" http://127.0.0.1:8080/status > /dev/null; then
            echo "[WATCHDOG] ❌ /status недоступен, перезапуск start.sh..."
            stop_proxy
            start_proxy
        else
            echo "[WATCHDOG] ✅ /status OK"
        fi
    done
}

# ────────── Первый старт ──────────
start_proxy

# ────────── Запуск цикла ──────────
watchdog_loop
