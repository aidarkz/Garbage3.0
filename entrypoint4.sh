#!/bin/bash

# Запуск HLS-прокси
/app/hls-proxy/hls-proxy -address 0.0.0.0 -port 8282 >> /app/hls.log 2>&1 &

# Запуск FastAPI
uvicorn stalker_hls_proxy:app --host 0.0.0.0 --port 8080 >> /app/api.log 2>&1 &

# Keepalive-монитор в фоне с логом
/app/keepalive.sh >> /app/keepalive-cron.log 2>&1 &

# Ждем завершения любого процесса
wait -n

# Если что-то упало — выходим с ошибкой
exit 1

