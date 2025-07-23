#!/bin/bash

WATCHDOG_INTERVAL=60
WATCHDOG_TIMEOUT=5
TEST_CHANNEL_ID=101

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

        echo "[WATCHDOG] 🔎 Проверка работоспособности HLS-канала..."

        TEST_URL="http://127.0.0.1:8080/channel/n58c5b493/index.m3u8?q=1753280172771"
        HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" --max-time "$WATCHDOG_TIMEOUT" "$TEST_URL")

        if [[ "$HTTP_CODE" != "200" ]]; then
            echo "[WATCHDOG] ❌ Канал $TEST_CHANNEL_ID не отвечает (код $HTTP_CODE), перезапуск..."
            stop_proxy
            start_proxy
        else
            echo "[WATCHDOG] ✅ Канал $TEST_CHANNEL_ID отвечает OK"
        fi
    done
}

# ────────── Первый запуск ──────────
start_proxy

# ────────── Запуск watchdog ──────────
watchdog_loop
