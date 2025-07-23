#!/bin/bash

HLS_PROXY_BIN="/opt/hlsp/hls-proxy"
PORT=8080
WATCHDOG_INTERVAL=60
WATCHDOG_TIMEOUT=5
TEST_CHANNEL_ID=101
TEST_URL="http://127.0.0.1:$PORT/channel/n58c5b493/index.m3u8?q=1753280172771"

start_proxy() {
    echo "[START] 🔄 Запуск HLS-прокси..."
    nohup $HLS_PROXY_BIN -address 0.0.0.0 -port $PORT > /tmp/proxy.log 2>&1 &
    PROXY_PID=$!
    echo $PROXY_PID > /tmp/proxy.pid
    echo "[WATCHDOG] 🔁 hls-proxy перезапущен с PID $PROXY_PID"
}

stop_proxy() {
    if [ -f /tmp/proxy.pid ]; then
        PID=$(cat /tmp/proxy.pid)
        if ps -p "$PID" > /dev/null; then
            echo "[WATCHDOG] 🛑 Остановка процесса PID $PID"
            kill "$PID"
            sleep 2
        fi
        rm -f /tmp/proxy.pid
    fi

    # safety: kill anyone on :8080
    PID2=$(lsof -ti:$PORT)
    if [ -n "$PID2" ]; then
        echo "[WATCHDOG] 🛑 Убиваем висячий процесс на :$PORT (PID $PID2)"
        kill "$PID2"
        sleep 2
    fi
}

check_channel() {
    HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" --max-time $WATCHDOG_TIMEOUT "$TEST_URL")
    [ "$HTTP_CODE" = "200" ]
}

# ─────── Первый запуск ───────
stop_proxy
start_proxy

# ─────── Watchdog цикл ───────
while true; do
    sleep $WATCHDOG_INTERVAL
    echo "[WATCHDOG] 🔎 Проверка работоспособности HLS-канала..."

    if check_channel; then
        echo "[WATCHDOG] ✅ Канал $TEST_CHANNEL_ID отвечает OK"
    else
        echo "[WATCHDOG] ❌ Канал $TEST_CHANNEL_ID не отвечает. Перезапуск..."
        stop_proxy
        start_proxy
    fi
done
