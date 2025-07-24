#!/bin/bash

# ──────── 1. Лог старта ────────
echo "[INIT] Container started at $(date)"

# ──────── 2. Запуск основного бинарника ────────
./hls-proxy &
PROXY_PID=$!
echo "[INIT] hls-proxy запущен с PID $PROXY_PID"

# ──────── 3. Keep-alive CURL ping ────────
keep_alive() {
  while true; do
    curl -s http://127.0.0.1:8080/status > /dev/null
    echo "[PING] $(date) → /health OK"
    sleep 60
  done
}
keep_alive &

# ──────── 4. Фоновая активность (анти-idle) ────────
anti_idle() {
  while true; do
    echo "[IDLE] $(date)" >> /tmp/container_awake.log
    tail -n 5 /tmp/container_awake.log > /dev/null
    sleep 10
  done
}
anti_idle &

# ──────── 5. PID 1: удержание контейнера ────────
tail -f /dev/null
