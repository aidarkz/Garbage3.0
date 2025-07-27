#!/bin/sh

# Запуск hls-proxy в фоне
echo "🟢 Стартует hls-proxy..."
/opt/hlsp/hls-proxy &

# Запуск nginx (обычно в foreground — пусть будет вторым)
echo "🟢 Стартует nginx..."
nginx

# Стартуем FastAPI-прокси (в foreground — он станет основным процессом)
echo "🟢 Стартует FastAPI-прокси..."
exec uvicorn stalker_hls_proxy:app --host 0.0.0.0 --port 8080
