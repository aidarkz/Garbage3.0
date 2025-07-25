#!/bin/sh

echo "[entrypoint] Container started at $(date)"

# Health-check пинги — работают в фоне
(
while true; do
    sleep 60
    echo "[entrypoint] Health ping at $(date)"
    curl -s http://127.0.0.1/health > /dev/null || echo "[entrypoint] Health check failed"
done
) &

# Основной цикл прокси — рестарт каждые 10 минут
while true; do
    echo "[entrypoint] Starting main.py at $(date)"
    python3 /app/main.py &
    MAIN_PID=$!

    # Спим 10 минут, потом убиваем main.py
    sleep 600
    echo "[entrypoint] Restarting main.py after 10 min..."
    kill -9 "$MAIN_PID"
    wait "$MAIN_PID" 2>/dev/null
done
