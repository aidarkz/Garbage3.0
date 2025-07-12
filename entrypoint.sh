#!/bin/sh

echo "[entrypoint] Container started at $(date)"

# Фоновый health-ping каждые 60 сек
(while true; do
    sleep 60
    echo "[entrypoint] Health ping at $(date)"
    curl -s http://127.0.0.1/health > /dev/null || echo "[entrypoint] Health check failed at $(date)"
done) &

# Авто‑перезапуск main.py каждые 2 часа
while true; do
    echo "[entrypoint] Starting main.py at $(date)"
    python3 /app/main.py
    echo "[entrypoint] Restarting main.py after 2h sleep..."
    sleep 7200
done
