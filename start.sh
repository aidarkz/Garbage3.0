#!/bin/sh

# Запускаем hls-proxy в фоне
/opt/hlsp/hls-proxy &

# Запускаем FastAPI-прокси на Uvicorn в фоне
uvicorn stalker_hls_proxy:app --host 0.0.0.0 --port 8080 &

# Главным процессом остаётся nginx (контейнер жив, пока жив nginx)
nginx
