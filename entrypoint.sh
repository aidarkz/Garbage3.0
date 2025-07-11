#!/bin/sh

echo "[entrypoint] Container started at $(date)"
echo "[entrypoint] Starting main.py..."

# Запускаем main.py в фоне
python3 /app/main.py &
MAIN_PID=$!

# Периодически делаем curl localhost, чтобы не дать контейнеру заснуть
while true; do
    sleep 60
    echo "[entrypoint] Health ping at $(date)"
    curl -s http://127.0.0.1/health > /dev/null || echo "[entrypoint] Health check failed at $(date)"
done

# на случай завершения основного процесса
wait $MAIN_PID
