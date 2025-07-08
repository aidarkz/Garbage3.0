#!/bin/bash
set -e

# Печать времени запуска
echo "[entrypoint] Container started at $(date)"

# Запуск сервера на 80 порту — твой main.py
echo "[entrypoint] Starting main.py..."
python3 /app/main.py &

# Можно добавить curl-запросы к localhost — чтобы симулировать активность
while true; do
    sleep 60
    curl -s http://127.0.0.1/health > /dev/null || echo "[entrypoint] Health check failed at $(date)"
done
