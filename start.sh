#!/bin/bash

# Запускаем Nginx, если нужен
nginx

# Даём 1 секунду на инициализацию
sleep 1

# Запускаем HLS-прокси в фоне с логированием
/opt/hlsp/hls-proxy -address 0.0.0.0:8080 >> /var/log/hls-proxy.log 2>&1 &

# Keep container alive (можно заменить на `tail -f` или `wait`)
while true; do
    sleep 60
done
